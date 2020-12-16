Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8D3C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B737A2342C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgLPRKp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgLPRKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:45 -0500
Date:   Wed, 16 Dec 2020 09:10:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138604;
        bh=6GedcVa0SEPNkHgJP+/ZnzsSPWkzmWL1je3ZWCGWA7k=;
        h=From:To:Subject:From;
        b=ONsG8DByO6vreUsTn3JrP9mQkO8dbzLFxNDToAtFELvW1fjD1JMdPCjhHerWXoY+G
         Hw0QbdZ2tlgnfewH/c6IMG5eXhPFsPNu2kwDo4Jl8MslqdJCuCQphUeTWoElHw0nrL
         Shmc1GiYe6iFFEF19uZDG6t+aE0konHPSwuHwt1U=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?checkpatch-add-=5F=5Falias-and-=5F=5Fweak-to-suggested?=
 =?US-ASCII?Q?-=5F=5Fattribute=5F=5F-conversions.patch?= removed from -mm
 tree
Message-ID: <20201216171004.dn_yxP-I-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add __alias and __weak to suggested __attribute__ conversions
has been removed from the -mm tree.  Its filename was
     checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add __alias and __weak to suggested __attribute__ conversions

Add __alias and __weak to the suggested __attribute__((<foo>))
conversions.

Link: https://lkml.kernel.org/r/7b74137743c58ce0633ec4d575b94e2210e4dbe7.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions
+++ a/scripts/checkpatch.pl
@@ -6200,6 +6200,7 @@ sub process {
 			$attr =~ s/\s*\(\s*(.*)\)\s*/$1/;
 
 			my %attr_list = (
+				"alias"				=> "__alias",
 				"aligned"			=> "__aligned",
 				"always_inline"			=> "__always_inline",
 				"assume_aligned"		=> "__assume_aligned",
@@ -6220,7 +6221,8 @@ sub process {
 				"packed"			=> "__packed",
 				"pure"				=> "__pure",
 				"section"			=> "__section",
-				"used"				=> "__used"
+				"used"				=> "__used",
+				"weak"				=> "__weak"
 			);
 
 			while ($attr =~ /\s*(\w+)\s*(${balanced_parens})?/g) {
_

Patches currently in -mm which might be from joe@perches.com are


