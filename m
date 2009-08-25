From: akpm@linux-foundation.org
Subject: [to-be-updated] kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch removed from -mm tree
Date: Tue, 25 Aug 2009 12:56:40 -0700
Message-ID: <200908251956.n7PJueem011818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339AbZHYT4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Aug 2009 15:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     define node_*_pfn for non-NUMA builds
has been removed from the -mm tree.  Its filename was
     kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: define node_*_pfn for non-NUMA builds
From: Jiri Slaby <jirislaby@gmail.com>

FWIW "Latest fs/proc/kcore updates" in the changelog are these
from mmotm:
> kcore-use-registerd-physmem-information.patch
> kcore-use-registerd-physmem-information-fix.patch
> kcore-use-registerd-physmem-information-checkpatch-fixes.patch

--

Latest fs/proc/kcore updates need node_end_pfn. To avoid a compiler
error:
fs/proc/kcore.c: In function `kcore_update_ram':
fs/proc/kcore.c:200: error: implicit declaration of function `node_end_pfn'
define node_start_pfn and node_end_pfn as simple contig_page_data
accessors on !NUMA builds.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/mmzone.h~kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds include/linux/mmzone.h
--- a/include/linux/mmzone.h~kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds
+++ a/include/linux/mmzone.h
@@ -775,6 +775,9 @@ extern char numa_zonelist_order[];
 extern struct pglist_data contig_page_data;
 #define NODE_DATA(nid)		(&contig_page_data)
 #define NODE_MEM_MAP(nid)	mem_map
+#define node_start_pfn(nid)	(contig_page_data.node_start_pfn)
+#define node_end_pfn(nid)	(contig_page_data.node_start_pfn +	\
+				 contig_page_data.node_spanned_pages)
 
 #else /* CONFIG_NEED_MULTIPLE_NODES */
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
gpu-vgaarb-use-%p-in-pointers-prints.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
usb-make-usb_buffer_map_sg-consistent-with-doc.patch
char-riscom8-fix-shutdown-declaration.patch
kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
kcore-use-registerd-physmem-information-fix2.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

