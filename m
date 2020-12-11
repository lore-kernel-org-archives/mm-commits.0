Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365E7C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 19:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA53623D97
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 19:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392767AbgLKSE6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 13:04:58 -0500
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:58802 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392278AbgLKSEc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 13:04:32 -0500
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2020 13:04:32 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id 3D25D180442CE
        for <mm-commits@vger.kernel.org>; Fri, 11 Dec 2020 17:54:12 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id D34F61801ED93;
        Fri, 11 Dec 2020 17:53:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: chair19_370033d27402
X-Filterd-Recvd-Size: 1625
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Fri, 11 Dec 2020 17:53:29 +0000 (UTC)
Message-ID: <32260871d4718ba7f48a8e9e07452bb76de300db.camel@perches.com>
Subject: Re: +
 checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch
 added to -mm tree
From:   Joe Perches <joe@perches.com>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Date:   Fri, 11 Dec 2020 09:53:27 -0800
In-Reply-To: <20201210000220.qQxGM%akpm@linux-foundation.org>
References: <20201210000220.qQxGM%akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 2020-12-09 at 16:02 -0800, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: checkpatch: add printk_once and printk_ratelimit to prefer pr_<level> warning
> has been added to the -mm tree.  Its filename is
>      checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch

I stuffed this one up.

It also needs:

 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 52f467fd32f9..00085308ed9d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4548,6 +4548,7 @@ sub process {
 			my $printk = $1;
 			my $modifier = $2;
 			my $orig = $3;
+			$modifier = "" if (!defined($modifier));
 			my $level = lc($orig);
 			$level = "warn" if ($level eq "warning");
 			my $level2 = $level;


