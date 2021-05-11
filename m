Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EC7C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 14:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF6BA61285
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 14:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhEKOgK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 10:36:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231154AbhEKOgK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 10:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620743703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yCuTPdf3sjR1pzINVw7uGPxic+Tys73broXyuoKqwjg=;
        b=gC6uadqpGJrR7A2HOnOHMATNen+4JDteJlVoaQoHKUBLQE0OBnDFPXRFkMi7avP8GUO4Xe
        OIBHkTRa4G1S1hxAu+uLgBBhYk7T0m0lgXhncMvG0hZ5MMjCMSKrEgsCpcuhw0JB5TvqZ8
        MyL44WzJ31SQmGBuRV8gnUyXGijOOXQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-cn3j_UZ9MISyQdpIkaUHDQ-1; Tue, 11 May 2021 10:34:59 -0400
X-MC-Unique: cn3j_UZ9MISyQdpIkaUHDQ-1
Received: by mail-qk1-f198.google.com with SMTP id z12-20020a05620a08ccb02902ea1e4a963dso14554458qkz.13
        for <mm-commits@vger.kernel.org>; Tue, 11 May 2021 07:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yCuTPdf3sjR1pzINVw7uGPxic+Tys73broXyuoKqwjg=;
        b=uYE+gauEztOc3hGFKCPqawF1pSlkL0DT1CktFsH98k+OyZiKEg8CgCBdOOPT2EqxyM
         G2h/LVbtLnkDNOmIbNdP2fHk8t9NZCKboNSPq9fvK6IYmWjj8/Yr0vIIH+hNZEYezUy1
         h+fAge6hYAjxK5VZBvD6AqPb3Fdv56Ir3wz5Dlb+UZDfrQwzTeVrf+0rTmoEu9rJv44o
         YI9wN+jsi+GbefY51PuC2qECsYi6idvcwIHYdDJUsGyTPCSCJVVjtC5dgE9k1K1gPQfC
         b8JYBpfQv39ywzjWqvTtV+7Dz43mvjJpgPES8N3FZvSZiRQMzgurrFNYMyeVeJX4f88Y
         PfoA==
X-Gm-Message-State: AOAM532EaGA6iXIJMpI0efYYhI9OzJ0I2okFdSdOAnhMrd+jZ0jXikuU
        WA5LP3etawaHXcT9IIPn4khgykswKPiJ+apNjxzMwjOoel0Edg2NCpE7TyjZ40YUTXBw2+PV29E
        JWNJ3MbSp0X4kG3E6smHWEw==
X-Received: by 2002:a37:9dd8:: with SMTP id g207mr28984709qke.340.1620743699396;
        Tue, 11 May 2021 07:34:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoaiDtwgZ+c1UthdfF4FMT49x4vBhMJIxnvQ57pN5SlucUjeesQIJQkK164g99eHZ05VjWXw==
X-Received: by 2002:a37:9dd8:: with SMTP id g207mr28984684qke.340.1620743699145;
        Tue, 11 May 2021 07:34:59 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id g5sm16529076qtm.2.2021.05.11.07.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 07:34:58 -0700 (PDT)
Date:   Tue, 11 May 2021 10:34:57 -0400
From:   Peter Xu <peterx@redhat.com>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org
Subject: Re: +
 mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch added to -mm
 tree
Message-ID: <YJqWESqyxa8OZA+2@t490s>
References: <20210509004001.OOWaE2Wyv%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="v7bA+u9HhtH1JIh8"
Content-Disposition: inline
In-Reply-To: <20210509004001.OOWaE2Wyv%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


--v7bA+u9HhtH1JIh8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sat, May 08, 2021 at 05:40:01PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes
> has been added to the -mm tree.  Its filename is
>      mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes
> 
> WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
> #25: 
> [peterx@redhat.com: fix build for task_mmu.c, introduce mm_set_has_pinned_flag, fix comments]
> 
> WARNING: please, no spaces at the start of a line
> #130: FILE: mm/gup.c:1280:
> +       if (!test_bit(MMF_HAS_PINNED, mm_flags))$
> 
> WARNING: suspect code indent for conditional statements (7, 15)
> #130: FILE: mm/gup.c:1280:
> +       if (!test_bit(MMF_HAS_PINNED, mm_flags))
> +               set_bit(MMF_HAS_PINNED, mm_flags);
> 
> ERROR: code indent should use tabs where possible
> #131: FILE: mm/gup.c:1281:
> +               set_bit(MMF_HAS_PINNED, mm_flags);$
> 
> WARNING: please, no spaces at the start of a line
> #131: FILE: mm/gup.c:1281:
> +               set_bit(MMF_HAS_PINNED, mm_flags);$
> 
> total: 1 errors, 4 warnings, 90 lines checked
> 
> NOTE: For some of the reported defects, checkpatch may be able to
>       mechanically convert to the typical style using --fix or --fix-inplace.
> 
> NOTE: Whitespace errors detected.
>       You may wish to use scripts/cleanpatch or scripts/cleanfile
> 
> ./patches/mm-gup-pack-has_pinned-in-mmf_has_pinned.patch has style problems, please review.
> 
> NOTE: If any of the errors are false positives, please report
>       them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> Please run checkpatch prior to sending patches

Andrew,

We may also need to squash attached into this commit, as otherwise !CONFIG_MMU
breaks.  Sorry about both of the troublesome I introduced!

(Note: the attached patch should be cleanly applied upon this space fix patch)

-- 
Peter Xu

--v7bA+u9HhtH1JIh8
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="0001-fixup-mm-gup-pack-has_pinned-in-MMF_HAS_PINNED.patch"

From e5558461f9ae20ae4c0266726db52c6f707e083b Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Tue, 11 May 2021 10:32:29 -0400
Subject: [PATCH] fixup! mm: gup: pack has_pinned in MMF_HAS_PINNED

This fixes build issue with !CONFIG_MMU.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/gup.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index be80873b80a77..67ced252edc75 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -392,6 +392,17 @@ void unpin_user_pages(struct page **pages, unsigned long npages)
 }
 EXPORT_SYMBOL(unpin_user_pages);
 
+/*
+ * Set the MMF_HAS_PINNED if not set yet; after set it'll be there for the mm's
+ * lifecycle.  Avoid setting the bit unless necessary, or it might cause write
+ * cache bouncing on large SMP machines for concurrent pinned gups.
+ */
+static inline void mm_set_has_pinned_flag(unsigned long *mm_flags)
+{
+	if (!test_bit(MMF_HAS_PINNED, mm_flags))
+		set_bit(MMF_HAS_PINNED, mm_flags);
+}
+
 #ifdef CONFIG_MMU
 static struct page *no_page_table(struct vm_area_struct *vma,
 		unsigned int flags)
@@ -1270,17 +1281,6 @@ int fixup_user_fault(struct mm_struct *mm,
 }
 EXPORT_SYMBOL_GPL(fixup_user_fault);
 
-/*
- * Set the MMF_HAS_PINNED if not set yet; after set it'll be there for the mm's
- * lifecycle.  Avoid setting the bit unless necessary, or it might cause write
- * cache bouncing on large SMP machines for concurrent pinned gups.
- */
-static inline void mm_set_has_pinned_flag(unsigned long *mm_flags)
-{
-	if (!test_bit(MMF_HAS_PINNED, mm_flags))
-		set_bit(MMF_HAS_PINNED, mm_flags);
-}
-
 /*
  * Please note that this function, unlike __get_user_pages will not
  * return 0 for nr_pages > 0 without FOLL_NOWAIT
-- 
2.31.1


--v7bA+u9HhtH1JIh8--

