Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7491EC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbjHKXAt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjHKW7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D6C1AE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC8F86492D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD14C433C7;
        Fri, 11 Aug 2023 22:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794779;
        bh=n4SwZe0sArp82qZhdLBEVF703cLPhUNsOzPikk1nrdo=;
        h=Date:To:From:Subject:From;
        b=APDCHha8CbSO4w0oII7NWY6nxnD2p8y85gfHJ9NxNAaLUECc+TllV3G68macyPKQ1
         l8au0c9Gpv81II0Ydaix0NqKph6oMktQwnTpxlQZ2+UQy+nUBxs0kdKWA4tpJ0LsHr
         1m1IkfedP2/jQ4yrrrYdKKR4Zbs+gioqqKH/cRjY=
Date:   Fri, 11 Aug 2023 15:59:38 -0700
To:     mm-commits@vger.kernel.org, liuq131@chinatelecom.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-redundant-judgments-from-macro-for_each_present_section_nr.patch removed from -mm tree
Message-Id: <20230811225939.3AD14C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/sparse: remove redundant judgments from macro for_each_present_section_nr
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-redundant-judgments-from-macro-for_each_present_section_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


