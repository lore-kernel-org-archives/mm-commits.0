Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CDBC4363D
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BFFD20BED
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601502388;
	bh=EmXDhOWs08jUQgCKIgAvXcOvkL/ISw4IfRgUTjbGS00=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IGBj96n4HWzF7bDZNRbLPGHhH+IpaFWNi6ciZ+oS7mB8RxHndZVKf4UzzkQgOX2GZ
	 6XcsEaTLEhK5eIoiEBF/S7A9n2GicAsksSPgYsFjhLiOpofUFPsgxRqLINktiEnAu5
	 qtv+gOYjQsE9ba1P3X8yWjt+VUWXJ97xJIEjKbHw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbgI3Vq2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730424AbgI3Vq1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 17:46:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D294520888;
        Wed, 30 Sep 2020 21:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601502386;
        bh=EmXDhOWs08jUQgCKIgAvXcOvkL/ISw4IfRgUTjbGS00=;
        h=Date:From:To:Subject:From;
        b=vCjlyssxSRCHBxx5Z6HUJ41EdTRlMd4fdPgCkY6mhgi3QGukJNNI1ZA85Ho66CHW9
         HZ5WSZpF/99gLIB5pYjNyn9VmP+hbxIvnmZ2WX3Cdb5E/HUHwb3cX/a2oNdSvwkt9t
         TxyNAriSXaF4kUanoFXD9WlMRHSZ4CYm8SZqSJbA=
Date:   Wed, 30 Sep 2020 14:46:25 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, farman@linux.ibm.com, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  + mm-slub-restore-initial-kmem_cache-flags.patch added to
 -mm tree
Message-ID: <20200930214625.Ah8FNFCfy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: restore initial kmem_cache flags
has been added to the -mm tree.  Its filename is
     mm-slub-restore-initial-kmem_cache-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-restore-initial-kmem_cache-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-restore-initial-kmem_cache-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Farman <farman@linux.ibm.com>
Subject: mm, slub: restore initial kmem_cache flags

The routine that applies debug flags to the kmem_cache slabs inadvertantly
prevents non-debug flags from being applied to those same objects.  That
is, if slub_debug=<flag>,<slab> is specified, non-debugged slabs will end
up having flags of zero, and the slabs may be unusable.

Fix this by including the input flags for non-matching slabs with the
contents of slub_debug, so that the caches are created as expected
alongside any debugging options that may be requested.  With this, we can
remove the check for a NULL slub_debug_string, since it's covered by the
loop itself.

Link: https://lkml.kernel.org/r/20200930161931.28575-1-farman@linux.ibm.com
Fixes: e17f1dfba37b ("mm, slub: extend slub_debug syntax for multiple blocks")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-restore-initial-kmem_cache-flags
+++ a/mm/slub.c
@@ -1413,10 +1413,6 @@ slab_flags_t kmem_cache_flags(unsigned i
 	char *next_block;
 	slab_flags_t block_flags;
 
-	/* If slub_debug = 0, it folds into the if conditional. */
-	if (!slub_debug_string)
-		return flags | slub_debug;
-
 	len = strlen(name);
 	next_block = slub_debug_string;
 	/* Go through all blocks of debug options, see if any matches our slab's name */
@@ -1450,7 +1446,7 @@ slab_flags_t kmem_cache_flags(unsigned i
 		}
 	}
 
-	return slub_debug;
+	return flags | slub_debug;
 }
 #else /* !CONFIG_SLUB_DEBUG */
 static inline void setup_object_debug(struct kmem_cache *s,
_

Patches currently in -mm which might be from farman@linux.ibm.com are

mm-slub-restore-initial-kmem_cache-flags.patch

