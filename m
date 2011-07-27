From: akpm@linux-foundation.org
Subject: + dma-debug-hash_bucket_find-needs-to-allow-for-offsets-within-an-entry.patch added to -mm tree
Date: Wed, 27 Jul 2011 16:00:27 -0700
Message-ID: <201107272300.p6RN0RHJ013702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754446Ab1G0XAx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 19:00:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, arnd@arndb.de, divy@chelsio.com, fenlason@redhat.com, joerg.roedel@amd.com, sgruszka@redhat.com


The patch titled
     dma-debug: hash_bucket_find() needs to allow for offsets within an entry
has been added to the -mm tree.  Its filename is
     dma-debug-hash_bucket_find-needs-to-allow-for-offsets-within-an-entry.patch

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
Subject: dma-debug: hash_bucket_find() needs to allow for offsets within an entry
From: Neil Horman <nhorman@tuxdriver.com>

Users of the pci_dma_sync_single_* api allow users to sync address ranges
within the range of a mapped entry (i.e.  you can dma map address X to
dma_addr_t A and then pci_dma_sync_single on dma_addr_t A+1.  The
dma-debug library however assume dma syncs will always occur using the
base address of a mapped region, and uses that assumption to find entries
in its hash table.  Since thats often (but not always the case), the dma
debug library can give us false errors about missing entries, which are
reported as syncing of memory not allocated by the driver.  This was noted
in the cxgb3 driver as this error:

WARNING: at lib/dma-debug.c:902 check_sync+0xdd/0x48c()
Hardware name: To be filled by O.E.M.
cxgb3 0000:01:00.0: DMA-API: device driver tries to sync DMA memory it has not
allocated [device address=0x00000000fff97800] [size=1984 bytes]
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table
mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 uinput
snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer e1000e snd soundcore r8169
cxgb3 iTCO_wdt snd_page_alloc mii shpchp i2c_i801 iTCO_vendor_support mdio
microcode firewire_ohci firewire_core crc_itu_t ata_generic pata_acpi i915
drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded:
scsi_wait_scan]
Pid: 1818, comm: ifconfig Not tainted 2.6.35-0.23.rc3.git6.fc14.x86_64 #1
Call Trace:
[<ffffffff81050f71>] warn_slowpath_common+0x85/0x9d
[<ffffffff8105102c>] warn_slowpath_fmt+0x46/0x48
[<ffffffff8124658e>] ? check_sync+0x39/0x48c
[<ffffffff8107c470>] ? trace_hardirqs_on+0xd/0xf
[<ffffffff81246632>] check_sync+0xdd/0x48c
[<ffffffff81246ca6>] debug_dma_sync_single_for_device+0x3f/0x41
[<ffffffffa011615c>] ? pci_map_page+0x84/0x97 [cxgb3]
[<ffffffffa0117bc3>] pci_dma_sync_single_for_device.clone.0+0x65/0x6e [cxgb3]
[<ffffffffa0117ed1>] refill_fl+0x305/0x30a [cxgb3]
[<ffffffffa011857d>] t3_sge_alloc_qset+0x6a7/0x821 [cxgb3]
[<ffffffffa010a07b>] cxgb_up+0x4d0/0xe62 [cxgb3]
[<ffffffff81086037>] ? __module_text_address+0x12/0x58
[<ffffffffa010aa4c>] cxgb_open+0x3f/0x309 [cxgb3]
[<ffffffff813e9f6c>] __dev_open+0x8e/0xbc
[<ffffffff813e7ca5>] __dev_change_flags+0xbe/0x142
[<ffffffff813e9ea8>] dev_change_flags+0x21/0x57
[<ffffffff81445937>] devinet_ioctl+0x29a/0x54b
[<ffffffff811f9a87>] ? inode_has_perm+0xaa/0xce
[<ffffffff81446ed2>] inet_ioctl+0x8f/0xa7
[<ffffffff813d683a>] sock_do_ioctl+0x29/0x48
[<ffffffff813d6c83>] sock_ioctl+0x213/0x222
[<ffffffff81137f78>] vfs_ioctl+0x32/0xa6
[<ffffffff811384e2>] do_vfs_ioctl+0x47a/0x4b3
[<ffffffff81138571>] sys_ioctl+0x56/0x79
[<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
---[ end trace 69a4d4cc77b58004 ]---

This patch corrects the issue by changing the hash_bucket_find function so
that it matches on entries where the referenced address and size fall
within the range of a given entry without overlapping.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Jay Fenalson <fenlason@redhat.com>
Cc: Divy LeRay <divy@chelsio.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-hash_bucket_find-needs-to-allow-for-offsets-within-an-entry lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-hash_bucket_find-needs-to-allow-for-offsets-within-an-entry
+++ a/lib/dma-debug.c
@@ -248,10 +248,23 @@ static struct dma_debug_entry *hash_buck
 {
 	struct dma_debug_entry *entry, *ret = NULL;
 	int matches = 0, match_lvl, last_lvl = 0;
+	u64 estart, eend, rstart, rend;
+
+	rstart = ref->dev_addr;
+	rend = rstart + ref->size;
 
 	list_for_each_entry(entry, &bucket->list, list) {
-		if ((entry->dev_addr != ref->dev_addr) ||
-		    (entry->dev != ref->dev))
+		estart = entry->dev_addr;
+		eend = estart + entry->size;
+
+		/*
+		 * An entry matches if the address range specified by the ref
+		 * dev_addr and size falls entirely within the range specified
+		 * by the entries dev_addr and size and the devices match
+		 */
+		if (entry->dev != ref->dev)
+			continue;
+		if ((estart > rstart) || (eend < rend))
 			continue;
 
 		/*
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
dma-debug-hash_bucket_find-needs-to-allow-for-offsets-within-an-entry.patch

