Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70E0C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 00:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D5920899
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 00:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594687823;
	bh=pE9qmp3mu+tvJaAQ4JQCaWGyH0YBrNqGOkygVUVG9Xk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ooXQT5sesaeZYD2HjnUzH4KgiRv5qsMOgfCocsYXvUBjk/PxDF6WVoOSgiaaFnN4G
	 Sq9mvA0jRseVtBVPVcw8fUuTTS9BUgiKXQz6o8AUB0kPFsnX48JzMIRR+OtzD/FTiy
	 i+HwhDccgjyyfEiL04fbzznemkIoZGKorvdvXgBw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgGNAuX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 20:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgGNAuX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 20:50:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A84E42075D;
        Tue, 14 Jul 2020 00:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594687822;
        bh=pE9qmp3mu+tvJaAQ4JQCaWGyH0YBrNqGOkygVUVG9Xk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uxsQgUbyjnmdzOtIsSC4Q+fEteieVIoNrAjfY1D/mi8pQS/BAiGY+Q4h6gjQIqgQ9
         wxseQPhhskHidf9POtTPTwZm74gGunP3PweTQsc6ZGGyfiy9ziGLBkK8LM7JyYYLX1
         R/5BXMlLciGW9Hu6wAGTTmrXgPWyyzr4QWVQ6F50=
Date:   Mon, 13 Jul 2020 17:50:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, grandmaster@al2klimov.de,
        mm-commits@vger.kernel.org
Subject:  + mm-thp-replace-http-links-with-https-ones.patch added
 to -mm tree
Message-ID: <20200714005022.H6jIOmEwJ%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: replace HTTP links with HTTPS ones=0D=0A=
has been added to the -mm tree.  Its filename is
     mm-thp-replace-http-links-with-https-ones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-replace-http-links-with=
-https-ones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-replace-http-links-with=
-https-ones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: "Alexander A. Klimov" <grandmaster@al2klimov.de>=0D=0A=
Subject: mm: thp: replace HTTP links with HTTPS ones=0D=0A=
=0D=0A=
Rationale:=0D=0A=
Reduces attack surface on kernel devs opening the links for MITM=0D=0A=
as HTTPS traffic is much harder to manipulate.=0D=0A=
=0D=0A=
Deterministic algorithm:=0D=0A=
For each file:=0D=0A=
  If not .svg:=0D=0A=
    For each line:=0D=0A=
      If doesn't contain `=08xmlns=08`:=0D=0A=
        For each link, `=08http://[^# 	=0D=0A=
]*(?:\w|/)`:=0D=0A=
	  If neither `=08gnu\.org/license`, nor `=08mozilla\.org/MPL=08`:=0D=0A=
            If both the HTTP and HTTPS versions=0D=0A=
            return 200 OK and serve the same content:=0D=0A=
              Replace HTTP with HTTPS.=0D=0A=
=0D=0A=
Link: http://lkml.kernel.org/r/20200713164345.36088-1-grandmaster@al2klimov=
.de=0D=0A=
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>=0D=0A=
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>=0D=0A=
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-replace-http-links-with-https-ones
+++ a/mm/huge_memory.c
@@ -2065,7 +2065,7 @@ static void __split_huge_pmd_locked(stru
 	 * free), userland could trigger a small page size TLB miss on the
 	 * small sized TLB while the hugepage TLB entry is still established in
 	 * the huge TLB. Some CPU doesn't like that.
-	 * See http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum
+	 * See https://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum
 	 * 383 on page 93. Intel should be safe but is also warns that it's
 	 * only safe if the permission and cache attributes of the two entries
 	 * loaded in the two TLB is identical (which should be the case here).
_

Patches currently in -mm which might be from grandmaster@al2klimov.de are

mm-thp-replace-http-links-with-https-ones.patch
vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch

