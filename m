Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE263C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiEJEXV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbiEJEWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734A31C06D5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 100056175A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7AFC385C8;
        Tue, 10 May 2022 04:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156259;
        bh=7D1wXJyz6jwpFAPlYTv0oSCyDGysQEB2UWecRyMN9tg=;
        h=Date:To:From:Subject:From;
        b=U35tlsmybxnWjkeAqz4Z5DsYvXJzCjTkh3eaL9x94ZbnLUtKQafxO5V93oU6B4CMq
         21WACBXIlYLGzY3XmMBN5FcS8ONBXcBppIgkyMf4mIlw1ykMDOMM0y5a74MCgE7stO
         vK7KgQuYu4cKQsKLAZK9rcyJ0bCsEN163w03pMYQ=
Date:   Mon, 09 May 2022 21:17:38 -0700
To:     mm-commits@vger.kernel.org, maz@kernel.org, joe@perches.com,
        robh@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_maintainer-honor-mailmap-for-in-file-emails.patch removed from -mm tree
Message-Id: <20220510041739.6E7AFC385C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: get_maintainer: Honor mailmap for in file emails
has been removed from the -mm tree.  Its filename was
     get_maintainer-honor-mailmap-for-in-file-emails.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


