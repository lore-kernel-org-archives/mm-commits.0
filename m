From: akpm@linux-foundation.org
Subject: + lib-proportionsc-trivial-sparse-lock-annotation.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:58:23 -0800
Message-ID: <200811122358.mACNwNG7005518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755415AbYKLX6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     lib: proportions.c trivial sparse lock annotation
has been added to the -mm tree.  Its filename is
     lib-proportionsc-trivial-sparse-lock-annotation.patch

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
Subject: lib: proportions.c trivial sparse lock annotation
From: Harvey Harrison <harvey.harrison@gmail.com>

Suppresses sparse warning:
lib/proportions.c:159:16: warning: context imbalance in 'prop_get_global': wrong count at exit
lib/proportions.c:159:16:    context 'RCU': wanted 0, got 1
lib/proportions.c:164:2: warning: context imbalance in 'prop_put_global': unexpected unlock
lib/proportions.c:164:2:    context 'RCU': wanted 0, got -1

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/proportions.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/proportions.c~lib-proportionsc-trivial-sparse-lock-annotation lib/proportions.c
--- a/lib/proportions.c~lib-proportionsc-trivial-sparse-lock-annotation
+++ a/lib/proportions.c
@@ -147,6 +147,7 @@ out:
  * this is used to track the active references.
  */
 static struct prop_global *prop_get_global(struct prop_descriptor *pd)
+__acquires(RCU)
 {
 	int index;
 
@@ -160,6 +161,7 @@ static struct prop_global *prop_get_glob
 }
 
 static void prop_put_global(struct prop_descriptor *pd, struct prop_global *pg)
+__releases(RCU)
 {
 	rcu_read_unlock();
 }
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
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch

