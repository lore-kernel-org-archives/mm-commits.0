From: akpm@linux-foundation.org
Subject: + fs-pstore-ramc-fix-up-section-annotations.patch added to -mm tree
Date: Tue, 23 Oct 2012 15:48:10 -0700
Message-ID: <20121023224810.AFCB8100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:34322 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587Ab2JWWsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 18:48:11 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so351193yen.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 15:48:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hare@suse.de, cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com


The patch titled
     Subject: fs/pstore/ram.c: fix up section annotations
has been added to the -mm tree.  Its filename is
     fs-pstore-ramc-fix-up-section-annotations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hannes Reinecke <hare@suse.de>
Subject: fs/pstore/ram.c: fix up section annotations

The compiler complained about missing section annotations.  Fix it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Colin Cross <ccross@android.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/ram.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/pstore/ram.c~fs-pstore-ramc-fix-up-section-annotations fs/pstore/ram.c
--- a/fs/pstore/ram.c~fs-pstore-ramc-fix-up-section-annotations
+++ a/fs/pstore/ram.c
@@ -287,8 +287,9 @@ static void ramoops_free_przs(struct ram
 	kfree(cxt->przs);
 }
 
-static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
-			      phys_addr_t *paddr, size_t dump_mem_sz)
+static int __devinit ramoops_init_przs(struct device *dev,
+				       struct ramoops_context *cxt,
+				       phys_addr_t *paddr, size_t dump_mem_sz)
 {
 	int err = -ENOMEM;
 	int i;
@@ -326,9 +327,10 @@ fail_prz:
 	return err;
 }
 
-static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
-			    struct persistent_ram_zone **prz,
-			    phys_addr_t *paddr, size_t sz, u32 sig)
+static int __devinit ramoops_init_prz(struct device *dev,
+				      struct ramoops_context *cxt,
+				      struct persistent_ram_zone **prz,
+				      phys_addr_t *paddr, size_t sz, u32 sig)
 {
 	if (!sz)
 		return 0;
_

Patches currently in -mm which might be from hare@suse.de are

fs-pstore-ramc-fix-up-section-annotations.patch

