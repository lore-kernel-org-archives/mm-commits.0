Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DF7C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFDA23159
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgLPEpb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgLPEpb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:31 -0500
Date:   Tue, 15 Dec 2020 20:44:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093890;
        bh=94wQpw4LZuy3PP4LHfkiFVh38pdvsvHzBWGCNKado2U=;
        h=From:To:Subject:In-Reply-To:From;
        b=dYKTnDby9x4Y/pmjq1SNU5VlCI9cig5tJab/uTYzKxuWNAWYtilCqRVnj4iuq/sDB
         74d9snOJVRMcgtIWCL2XBcVs3XHN0N/niZUZGnwJUeItmpAONqJ1jQo/IYXn40p563
         BrZfZn1XmfE1N1iQVAL1+9L2efitDWtnoiXQ/NWE=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 46/95] checkpatch: add __alias and __weak to
 suggested __attribute__ conversions
Message-ID: <20201216044450.ADvkSUYgO%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
