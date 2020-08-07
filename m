Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FD1C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C29F22CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781570;
	bh=2xJbUln9aDC0YWWrHAT4MCCjeEmJ50MCGNZYEQbYMRo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Rj9QRexeez6ZW0sYeco53c6UerGKwOxFF7Evfihz76lCu27e/Yey+Vu2yr6wt0jfD
	 kx1E+VUf2A56bAEzWhAT199PjTBlCRk7RTNbEYmAS5UBj5HIepAr/viAkkCZ3Tu54q
	 ONulYK5aDK37OEkB7JMILOy9utco3TR4/HUHN1O4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHGG0K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGG0J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:26:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF4BA22CF6;
        Fri,  7 Aug 2020 06:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781569;
        bh=2xJbUln9aDC0YWWrHAT4MCCjeEmJ50MCGNZYEQbYMRo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TRzxUwsUSsVrC+ZpoYFDMttKhbSoKX5fzak+9d0g0C+9qAkwuP/tzGDGOr66N34aC
         ByOXxptRA5E7qqKboQSW0epY6bDFcoUTaTovU41DZq4qKO/8xemZmUdTkjvwbP+qJx
         +iu850KsdnCDlWxzwMHE8l3cYkMqNTHUqZHs1vZ0=
Date:   Thu, 06 Aug 2020 23:26:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, grandmaster@al2klimov.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 156/163] mm: thp: replace HTTP links with HTTPS
 ones
Message-ID: <20200807062608.WadMSEwki%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: mm: thp: replace HTTP links with HTTPS ones

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `xmlns`:
        For each link, `http://[^# 	]*(?:\w|/)`:
	  If neither `gnu\.org/license`, nor `mozilla\.org/MPL`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

[akpm@linux-foundation.org: fix amd.com URL, per Vlastimil]
Link: http://lkml.kernel.org/r/20200713164345.36088-1-grandmaster@al2klimov.de
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-replace-http-links-with-https-ones
+++ a/mm/huge_memory.c
@@ -2063,8 +2063,8 @@ static void __split_huge_pmd_locked(stru
 	 * free), userland could trigger a small page size TLB miss on the
 	 * small sized TLB while the hugepage TLB entry is still established in
 	 * the huge TLB. Some CPU doesn't like that.
-	 * See http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum
-	 * 383 on page 93. Intel should be safe but is also warns that it's
+	 * See http://support.amd.com/TechDocs/41322_10h_Rev_Gd.pdf, Erratum
+	 * 383 on page 105. Intel should be safe but is also warns that it's
 	 * only safe if the permission and cache attributes of the two entries
 	 * loaded in the two TLB is identical (which should be the case here).
 	 * But it is generally safer to never allow small and huge TLB entries
_
