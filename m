From: akpm@linux-foundation.org
Subject: [merged]
 kexec-fix-out-of-the-elf-headers-buffer-issue-in-syscall-kexec_file_load.patch removed from -mm tree
Date: Fri, 02 Oct 2015 12:36:41 -0700
Message-ID: <560edcc9.sxZz5LJJN0bQflCP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbJBTgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 15:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joeyli.kernel@gmail.com, bhe@redhat.com, dyoung@redhat.com, hpa@zytor.com, jiang.liu@linux.intel.com, jlee@suse.com, luto@kernel.org, mhuang@redhat.com, mingo@redhat.com, sfr@canb.auug.org.au, tglx@linutronix.de, tiwai@suse.de, vgoyal@redhat.com, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix out of the ELF headers buffer issue in syscall kexec_file_load()
has been removed from the -mm tree.  Its filename was
     kexec-fix-out-of-the-elf-headers-buffer-issue-in-syscall-kexec_file_load.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: kexec: fix out of the ELF headers buffer issue in syscall kexec_file_load()

This patch modifies the code in fill_up_crash_elf_data() by using
walk_system_ram_res() instead of walk_system_ram_range() to count the max
number of crash memory ranges.  That's because walk_system_ram_range()
filters out small memory regions that reside in the same page, but
walk_system_ram_res() does not.

The oringial issue is page fault error that sometimes happened on big
machines when preparing ELF headers:

[  305.291522] BUG: unable to handle kernel paging request at ffffc90613fc9000
[  305.299621] IP: [<ffffffff8103d645>] prepare_elf64_ram_headers_callback+0x165/0x260
[  305.308300] PGD e000032067 PUD 6dcbec54067 PMD 9dc9bdeb067 PTE 0
[  305.315393] Oops: 0002 [#1] SMP
[...snip]
[  305.420953] task: ffff8e1c01ced600 ti: ffff8e1c03ec2000 task.ti: ffff8e1c03ec2000
[  305.429292] RIP: 0010:[<ffffffff8103d645>]  [<ffffffff8103d645>] prepare_elf64_ra
m_headers_callback+0x165/0x260
[...snip]

After tracing prepare_elf64_headers() and
prepare_elf64_ram_headers_callback(), the code uses walk_system_ram_res()
to fill-in crash memory regions information to program header, so it
counts those small memory regions that reside in a page area.  But when
the kernel was using walk_system_ram_range() in fill_up_crash_elf_data()
to count the number of crash memory regions, it filters out small regions.
I printed those small memory regions, for example:

kexec: Get nr_ram ranges. vaddr=0xffff880077592258 paddr=0x77592258, sz=0xdc0

Base on the code in walk_system_ram_range(), this memory region will be
filtered out:

pfn = (0x77592258 + 0x1000 - 1) >> 12 = 0x77593
end_pfn = (0x77592258 + 0xfc0 -1 + 1) >> 12 = 0x77593
end_pfn - pfn = 0x77593 - 0x77593 = 0  <=== if (end_pfn > pfn) is FALSE

So, the max_nr_ranges that's counted by kernel doesn't include small
memory regions.  That causes the page fault in later code path for
preparing EFL headers.

This issue is not easy to reproduce on small machines that don't have too
many CPUs because the allocated page aligned ELF buffer has more free
space to cover those small memory regions' PT_LOAD headers.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Acked-by: Dave Young <dyoung@redhat.com>
Reviewed-by: Minfei Huang <mhuang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/crash.c~kexec-fix-out-of-the-elf-headers-buffer-issue-in-syscall-kexec_file_load arch/x86/kernel/crash.c
--- a/arch/x86/kernel/crash.c~kexec-fix-out-of-the-elf-headers-buffer-issue-in-syscall-kexec_file_load
+++ a/arch/x86/kernel/crash.c
@@ -185,10 +185,9 @@ void native_machine_crash_shutdown(struc
 }
 
 #ifdef CONFIG_KEXEC_FILE
-static int get_nr_ram_ranges_callback(unsigned long start_pfn,
-				unsigned long nr_pfn, void *arg)
+static int get_nr_ram_ranges_callback(u64 start, u64 end, void *arg)
 {
-	int *nr_ranges = arg;
+	unsigned int *nr_ranges = arg;
 
 	(*nr_ranges)++;
 	return 0;
@@ -214,7 +213,7 @@ static void fill_up_crash_elf_data(struc
 
 	ced->image = image;
 
-	walk_system_ram_range(0, -1, &nr_ranges,
+	walk_system_ram_res(0, -1, &nr_ranges,
 				get_nr_ram_ranges_callback);
 
 	ced->max_nr_ranges = nr_ranges;
_

Patches currently in -mm which might be from joeyli.kernel@gmail.com are


