From: akpm@linux-foundation.org
Subject: + lib-fix-sparse-shadowed-variable-warning.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:57:38 -0800
Message-ID: <200811122357.mACNvc7M005184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbYKLX6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:58:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     lib: fix sparse shadowed variable warning
has been added to the -mm tree.  Its filename is
     lib-fix-sparse-shadowed-variable-warning.patch

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
Subject: lib: fix sparse shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>

pos is always set before being used, no need to declare a
second one inside the if() block.

lib/prio_heap.c:34:7: warning: symbol 'pos' shadows an earlier one
lib/prio_heap.c:30:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/prio_heap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/prio_heap.c~lib-fix-sparse-shadowed-variable-warning lib/prio_heap.c
--- a/lib/prio_heap.c~lib-fix-sparse-shadowed-variable-warning
+++ a/lib/prio_heap.c
@@ -31,7 +31,7 @@ void *heap_insert(struct ptr_heap *heap,
 
 	if (heap->size < heap->max) {
 		/* Heap insertion */
-		int pos = heap->size++;
+		pos = heap->size++;
 		while (pos > 0 && heap->gt(p, ptrs[(pos-1)/2])) {
 			ptrs[pos] = ptrs[(pos-1)/2];
 			pos = (pos-1)/2;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
cifs-remove-global_extern-macro.patch
dlm-trivial-annotation-of-be16-value.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
wusb-annotate-association-types-withe-proper-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch

