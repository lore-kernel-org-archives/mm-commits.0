From: akpm@linux-foundation.org
Subject: + sysctl-add-support-for-poll-fix.patch added to -mm tree
Date: Fri, 26 Aug 2011 14:06:26 -0700
Message-ID: <201108262106.p7QL6Qe7012038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149Ab1HZVHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 17:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, ebiederm@xmission.com, gregkh@suse.de, kay.sievers@vrfy.org, lucas.demarchi@profusion.mobi, viro@zeniv.linux.org.uk


The patch titled
     sysctl-add-support-for-poll-fix
has been added to the -mm tree.  Its filename is
     sysctl-add-support-for-poll-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl-add-support-for-poll-fix
From: Andrew Morton <akpm@linux-foundation.org>

s/declare/define/ for definitions

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h  |    2 +-
 kernel/utsname_sysctl.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-add-support-for-poll-fix include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-support-for-poll-fix
+++ a/include/linux/sysctl.h
@@ -1029,7 +1029,7 @@ void proc_sys_poll_notify(struct ctl_tab
 	.event = ATOMIC_INIT(0),					\
 	.wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.wait) }
 
-#define DECLARE_CTL_TABLE_POLL(name)					\
+#define DEFINE_CTL_TABLE_POLL(name)					\
 	struct ctl_table_poll name = __CTL_TABLE_POLL_INITIALIZER(name)
 
 /* A sysctl table is an array of struct ctl_table: */
diff -puN kernel/utsname_sysctl.c~sysctl-add-support-for-poll-fix kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~sysctl-add-support-for-poll-fix
+++ a/kernel/utsname_sysctl.c
@@ -62,8 +62,8 @@ static int proc_do_uts_string(ctl_table 
 #define proc_do_uts_string NULL
 #endif
 
-static DECLARE_CTL_TABLE_POLL(hostname_poll);
-static DECLARE_CTL_TABLE_POLL(domainname_poll);
+static DEFINE_CTL_TABLE_POLL(hostname_poll);
+static DEFINE_CTL_TABLE_POLL(domainname_poll);
 
 static struct ctl_table uts_kern_table[] = {
 	{
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
kernel-rtmutexc-fix-warning-improve-coding-style.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

