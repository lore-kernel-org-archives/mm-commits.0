From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 02/11] mm/memory_hotplug: don't free usage map when
 removing a re-added early section
Date: Mon, 13 Jan 2020 16:29:07 -0800
Message-ID: <20200114002907.gub3R%akpm@linux-foundation.org>
References: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728918AbgANA3I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:08 -0500
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piliu@redhat.com, osalvador@suse.de, mhocko@kernel.org, dan.j.williams@intel.com, david@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: don't free usage map when removing a re-added early section

When we remove an early section, we don't free the usage map, as the usage
maps of other sections are placed into the same page.  Once the section is
removed, it is no longer an early section (especially, the memmap is
freed).  When we re-add that section, the usage map is reused, however, it
is no longer an early section.  When removing that section again, we try
to kfree() a usage map that was allocated during early boot - bad.

Let's check against PageReserved() to see if we are dealing with an usage
map that was allocated during boot.  We could also check against
!(PageSlab(usage_page) || PageCompound(usage_page)), but PageReserved() is
cleaner.

Can be triggered using memtrace under ppc64/powernv:

$ mount -t debugfs none /sys/kernel/debug/
$ echo 0x20000000 > /sys/kernel/debug/powerpc/memtrace/enable
$ echo 0x20000000 > /sys/kernel/debug/powerpc/memtrace/enable
[   12.093442] ------------[ cut here ]------------
[   12.093469] kernel BUG at mm/slub.c:3969!
[   12.093656] Oops: Exception in kernel mode, sig: 5 [#1]
[   12.093961] LE PAGE_SIZE=3D64K MMU=3DHash SMP NR_CPUS=3D2048 NUMA Powe=
rNV
[   12.094320] Modules linked in:
[   12.094615] CPU: 0 PID: 154 Comm: sh Not tainted 5.5.0-rc2-next-201912=
16-00005-g0be1dba7b7c0 #61
[   12.095066] NIP:  c000000000396b38 LR: c000000000385848 CTR: c00000000=
0143d30
[   12.095427] REGS: c000000073077680 TRAP: 0700   Not tainted  (5.5.0-rc=
2-next-20191216-00005-g0be1dba7b7c0)
[   12.095886] MSR:  900000000282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE=
>  CR: 28004828  XER: 20000000
[   12.096395] CFAR: c000000000396b9c IRQMASK: 0
[   12.096395] GPR00: c000000000385848 c000000073077910 c00000000110f300 =
c00000007ffffc00
[   12.096395] GPR04: 0000000000000000 ffffffffffffffff 0000000000000000 =
0000000000000000
[   12.096395] GPR08: 0000000000000000 0000000000000001 0000000000000000 =
ffffffffffffffc8
[   12.096395] GPR12: 0000000000004000 c0000000012d0000 0000000000001000 =
c000000000d33c78
[   12.096395] GPR16: 0000000000000000 c0000000011bfeb0 ffffffffffffe000 =
c0000000000b6370
[   12.096395] GPR20: ffffffffe0000000 c0000000011411c0 0000000000006000 =
c0000000000b6390
[   12.096395] GPR24: 0000000010000000 0000000000000040 0000000000000000 =
0000000000000000
[   12.096395] GPR28: c000000000385848 c00c0000001fffc0 0000000000004000 =
0000000000000000
[   12.099882] NIP [c000000000396b38] kfree+0x338/0x3b0
[   12.100135] LR [c000000000385848] section_deactivate+0x138/0x200
[   12.100508] Call Trace:
[   12.100927] [c000000073077910] [c0000000010599a8] 0xc0000000010599a8 (=
unreliable)
[   12.101338] [c000000073077960] [c000000000385848] section_deactivate+0=
x138/0x200
[   12.101696] [c000000073077a10] [c00000000039b9f4] __remove_pages+0x114=
/0x150
[   12.102025] [c000000073077a60] [c00000000006793c] arch_remove_memory+0=
x3c/0x160
[   12.102381] [c000000073077ae0] [c00000000039c154] try_remove_memory+0x=
114/0x1a0
[   12.102715] [c000000073077b90] [c00000000039c020] __remove_memory+0x20=
/0x40
[   12.103041] [c000000073077bb0] [c0000000000b6714] memtrace_enable_set+=
0x254/0x850
[   12.103402] [c000000073077cb0] [c0000000004197e8] simple_attr_write+0x=
138/0x160
[   12.103751] [c000000073077d10] [c000000000558c9c] full_proxy_write+0x8=
c/0x110
[   12.104100] [c000000073077d60] [c0000000003d02a8] __vfs_write+0x38/0x7=
0
[   12.104409] [c000000073077d80] [c0000000003d3c5c] vfs_write+0x11c/0x2a=
0
[   12.104711] [c000000073077dd0] [c0000000003d4054] ksys_write+0x84/0x14=
0
[   12.105011] [c000000073077e20] [c00000000000b594] system_call+0x5c/0x6=
8
[   12.105357] Instruction dump:
[   12.105606] e93d0000 75290001 41820090 8bfd0051 38a0ffff 7ca5f830 7bff=
0020 7ca507b4
[   12.105993] e95d0000 39200000 754a0001 4182005c <0b090000> 893d0007 3d=
42000b 38800006
[   12.106583] ---[ end trace 4b053cbd84e0db62 ]---

The first invocation will offline+remove memory blocks. The second
invocation will first add+online them again, in order to offline+remove
them again (usually we are lucky and the exact same memory blocks will
get "reallocated").

Tested on powernv with boot memory: The usage map will not get freed.
Tested on x86-64 with DIMMs: The usage map will get freed.

Using Dynamic Memory under a Power DLAPR can trigger it easily. 
Triggering removal (I assume after previously removed+re-added) of
memory from the HMC GUI can crash the kernel with the same call trace
and is fixed by this patch.

Link: http://lkml.kernel.org/r/20191217104637.5509-1-david@redhat.com
Fixes: 326e1b8f83a4 ("mm/sparsemem: introduce a SECTION_IS_EARLY flag")
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Pingfan Liu <piliu@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/sparse.c~mm-memory_hotplug-dont-free-usage-map-when-removing-a-re-added-early-section
+++ a/mm/sparse.c
@@ -777,7 +777,14 @@ static void section_deactivate(unsigned
 	if (bitmap_empty(subsection_map, SUBSECTIONS_PER_SECTION)) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
 
-		if (!section_is_early) {
+		/*
+		 * When removing an early section, the usage map is kept (as the
+		 * usage maps of other sections fall into the same page). It
+		 * will be re-used when re-adding the section - which is then no
+		 * longer an early section. If the usage map is PageReserved, it
+		 * was allocated during boot.
+		 */
+		if (!PageReserved(virt_to_page(ms->usage))) {
 			kfree(ms->usage);
 			ms->usage = NULL;
 		}
_
