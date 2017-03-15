From: akpm@linux-foundation.org
Subject: + kref-remove-warn_on-for-null-release-functions.patch added to
 -mm tree
Date: Wed, 15 Mar 2017 14:49:19 -0700
Message-ID: <58c9b6df.8k353n+X7ot9+yfK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54574 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753319AbdCOVtV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 17:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kref: remove WARN_ON for NULL release functions
has been added to the -mm tree.  Its filename is
     kref-remove-warn_on-for-null-release-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kref-remove-warn_on-for-null-release-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kref-remove-warn_on-for-null-release-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: kref: remove WARN_ON for NULL release functions

The kref functions check for NULL release functions.  This WARN_ON seems
rather pointless.  We will eventually release and then just crash nicely. 
It is also somewhat expensive because these functions are inlined in a lot
of places.  Removing the WARN_ONs saves around 2.3k in this kernel (likely
more in others with more drivers)

   text    data     bss     dec     hex filename
9083992 5367600 11116544        25568136        1862388 vmlinux-before-load-avg
9070166 5367600 11116544        25554310        185ed86 vmlinux-load-avg

Link: http://lkml.kernel.org/r/20170315021431.13107-5-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kref.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/kref.h~kref-remove-warn_on-for-null-release-functions include/linux/kref.h
--- a/include/linux/kref.h~kref-remove-warn_on-for-null-release-functions
+++ a/include/linux/kref.h
@@ -66,8 +66,6 @@ static inline void kref_get(struct kref
  */
 static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref))
 {
-	WARN_ON(release == NULL);
-
 	if (refcount_dec_and_test(&kref->refcount)) {
 		release(kref);
 		return 1;
@@ -79,8 +77,6 @@ static inline int kref_put_mutex(struct
 				 void (*release)(struct kref *kref),
 				 struct mutex *lock)
 {
-	WARN_ON(release == NULL);
-
 	if (refcount_dec_and_mutex_lock(&kref->refcount, lock)) {
 		release(kref);
 		return 1;
@@ -92,8 +88,6 @@ static inline int kref_put_lock(struct k
 				void (*release)(struct kref *kref),
 				spinlock_t *lock)
 {
-	WARN_ON(release == NULL);
