Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB50C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 20:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiCYUfM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiCYUfM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 16:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D120C84EF0
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 13:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68624B829E5
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA09C2BBE4;
        Fri, 25 Mar 2022 20:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648240413;
        bh=k15uvEWubcVIADVKGMHEF7qJxnz6Abhy4mE7yjMbEOw=;
        h=Date:To:From:Subject:From;
        b=ySoDNYi6jYGy2RH1hb+RCTnPUvG6S2tFQMgKeGiCF71tVq2XIMRXc8sQE+6JJ0N4t
         OUs1IcINV00tM5Y3tK2LOWUlvBSSo1WueC+sA3+CotVN1a/CY4iA17sUqn/nk4RxSX
         Hxdi0Xj3fXacCBAlVKXS8xvMPusqlLC8knBKriDc=
Date:   Fri, 25 Mar 2022 13:33:32 -0700
To:     mm-commits@vger.kernel.org, maz@kernel.org, joe@perches.com,
        robh@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainer-honor-mailmap-for-in-file-emails.patch added to -mm tree
Message-Id: <20220325203332.EFA09C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: Honor mailmap for in file emails
has been added to the -mm tree.  Its filename is
     get_maintainer-honor-mailmap-for-in-file-emails.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-honor-mailmap-for-in-file-emails.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-honor-mailmap-for-in-file-emails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Herring <robh@kernel.org>
Subject: get_maintainer: Honor mailmap for in file emails

Add support to also use the mailmap for 'in file' email addresses.

Link: https://lkml.kernel.org/r/20220323193645.317514-1-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Reported-by: Marc Zyngier <maz@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/get_maintainer.pl~get_maintainer-honor-mailmap-for-in-file-emails
+++ a/scripts/get_maintainer.pl
@@ -983,6 +983,7 @@ sub get_maintainers {
 	}
 
 	foreach my $email (@file_emails) {
+	    $email = mailmap_email($email);
 	    my ($name, $address) = parse_email($email);
 
 	    my $tmp_email = format_email($name, $address, $email_usename);
_

Patches currently in -mm which might be from robh@kernel.org are

get_maintainer-honor-mailmap-for-in-file-emails.patch

