Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77FBC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEE55206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196110;
	bh=GGKU3pIphwKEA43mBAljbzy72wm71aowjyKjOBeeyO8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=t5LtIl2wrXEbN1knq+umKHe/+DUDVlZlde+6BFvLHn8P4gbuHZQCK20OGFxLwwIxu
	 DGO76wLkXFJfGB/fxBPdA8TGDEJRQ0rB5tGqlVUuHPi0K5MGWy5LWOYcsGTJCCkbup
	 TxilFWX6KSdtpDHhztXXOAEW08J+pfyF+ysuKrJQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgHLBfK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgHLBfI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8798C207F7;
        Wed, 12 Aug 2020 01:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196107;
        bh=GGKU3pIphwKEA43mBAljbzy72wm71aowjyKjOBeeyO8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AiB4Dcs3MLEp7cLp7Zh2u3VMlb+hPzSMu8pkJbU49uaiNW1DFd+skrvIrjKqY7GKL
         86VLXtbzsj1HwYfsWwzY1Q69mg8THmazo9gl0F29GBfZuJ1G6b/TpjutS2lGquQr4w
         K5DZmwISTihAM440VtwD+ge097fLVabkG9yriSWQ=
Date:   Tue, 11 Aug 2020 18:35:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 092/165] checkpatch: add test for possible misuse
 of IS_ENABLED() without CONFIG_
Message-ID: <20200812013507.CmUZ11c97%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for possible misuse of IS_ENABLED() without CONFIG_

IS_ENABLED is almost always used with CONFIG_<FOO> defines.

Add a test to verify that the #define being tested starts with CONFIG_.

Link: http://lkml.kernel.org/r/e7fda760b91b769ba82844ba282d432c0d26d709.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_
+++ a/scripts/checkpatch.pl
@@ -6465,6 +6465,12 @@ sub process {
 			}
 		}
 
+# check for IS_ENABLED() without CONFIG_<FOO> ($rawline for comments too)
+		if ($rawline =~ /\bIS_ENABLED\s*\(\s*(\w+)\s*\)/ && $1 !~ /^CONFIG_/) {
+			WARN("IS_ENABLED_CONFIG",
+			     "IS_ENABLED($1) is normally used as IS_ENABLED(CONFIG_$1)\n" . $herecurr);
+		}
+
 # check for #if defined CONFIG_<FOO> || defined CONFIG_<FOO>_MODULE
 		if ($line =~ /^\+\s*#\s*if\s+defined(?:\s*\(?\s*|\s+)(CONFIG_[A-Z_]+)\s*\)?\s*\|\|\s*defined(?:\s*\(?\s*|\s+)\1_MODULE\s*\)?\s*$/) {
 			my $config = $1;
_
