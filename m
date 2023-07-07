Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEB7C001DD
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 19:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjGGT3r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 15:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjGGT1p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 15:27:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9D0129
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 12:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E2EA61A53
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 19:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB74C433C7;
        Fri,  7 Jul 2023 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688758008;
        bh=FnPtMQpxHw8yN0LrDA0NymUrC5WxZjoX+XLHlaTwHWo=;
        h=Date:To:From:Subject:From;
        b=Zh7KNzBvSZFNHS2Ivctt5XUau4sjip8t+LezBQrhBAMVPreXYJM/m+O4voBKC6D/a
         9V8HTYTUiP3AaNqVsfsxq3jA2biT6msWS4r9HsMRn9i01gCL0l4dp+nVcXTCqyPrYH
         IVwVlqKTyqkvzZQWs09Xs7/FyoxtYSpIS7oQ1Z4U=
Date:   Fri, 07 Jul 2023 12:26:48 -0700
To:     mm-commits@vger.kernel.org, liuq131@chinatelecom.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-remove-redundant-judgments-from-macro-for_each_present_section_nr.patch added to mm-unstable branch
Message-Id: <20230707192648.AEB74C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: remove redundant judgments from macro for_each_present_section_nr
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-remove-redundant-judgments-from-macro-for_each_present_section_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-remove-redundant-judgments-from-macro-for_each_present_section_nr.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: liuq <liuq131@chinatelecom.cn>
Subject: mm/sparse: remove redundant judgments from macro for_each_present_section_nr
Date: Fri, 7 Jul 2023 14:05:01 +0800

next_present_section_nr() has already ensured that
'section_nr<=__highest_present_section_nr', so this check is removed.

Link: https://lkml.kernel.org/r/20230707060501.29184-1-liuq131@chinatelecom.cn
Signed-off-by: liuq <liuq131@chinatelecom.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/sparse.c~mm-sparse-remove-redundant-judgments-from-macro-for_each_present_section_nr
+++ a/mm/sparse.c
@@ -172,8 +172,7 @@ static void __section_mark_present(struc
 
 #define for_each_present_section_nr(start, section_nr)		\
 	for (section_nr = next_present_section_nr(start-1);	\
-	     ((section_nr != -1) &&				\
-	      (section_nr <= __highest_present_section_nr));	\
+	     section_nr != -1;								\
 	     section_nr = next_present_section_nr(section_nr))
 
 static inline unsigned long first_present_section_nr(void)
_

Patches currently in -mm which might be from liuq131@chinatelecom.cn are

mm-page_alloc-fix-min_free_kbytes-calculation-regarding-zone_movable.patch
mm-sparse-remove-redundant-judgments-from-macro-for_each_present_section_nr.patch

