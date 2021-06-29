Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618F4C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BFBD611AE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhF2CoD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231799AbhF2CoC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35EEF61D0C;
        Tue, 29 Jun 2021 02:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934495;
        bh=/N6u5bJybcCpXgkdOdLH2P2WlsRZDg7azdf+esj2QXM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gi8geiCgDzDgvE7BG0uXaIZMChRebKRSeHOjoKs2D44I9ehg3TkHSSD86ONu9sOcS
         Rd/WKOIRL9ZuHtUzCYty1ecHr/FCIKn3W1QOYwT+rkHy5Af58/oqEOJRAgOcgLJu0U
         qRz4ZKS33sxcB9fLTLKk+uY7o10IzR9x+fg2coCY=
Date:   Mon, 28 Jun 2021 19:41:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     acme@redhat.com, akpm@linux-foundation.org, andrii@kernel.org,
        haoluo@google.com, jolsa@kernel.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        msuchanek@suse.de, torvalds@linux-foundation.org
Subject:  [patch 159/192] kbuild: skip per-CPU BTF generation for
 pahole v1.18-v1.21
Message-ID: <20210629024134.P29WLt5IS%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>
Subject: kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21

Commit "mm/page_alloc: convert per-cpu list protection to local_lock" will
introduce a zero-sized per-CPU variable, which causes pahole to generate
invalid BTF.  Only pahole versions 1.18 through 1.21 are impacted, as
before 1.18 pahole doesn't know anything about per-CPU variables, and 1.22
contains the proper fix for the issue.

Luckily, pahole 1.18 got --skip_encoding_btf_vars option disabling BTF
generation for per-CPU variables in anticipation of some unanticipated
problems.  So use this escape hatch to disable per-CPU var BTF info on
those problematic pahole versions.  Users relying on availability of
per-CPU var BTFs would need to upgrade to pahole 1.22+, but everyone won't
notice any regressions.

Link: https://lkml.kernel.org/r/20210530002536.3193829-1-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/link-vmlinux.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/link-vmlinux.sh~kbuild-skip-per-cpu-btf-generation-for-pahole-v118-v121
+++ a/scripts/link-vmlinux.sh
@@ -235,6 +235,10 @@ gen_btf()
 
 	vmlinux_link ${1}
 
+	if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
+		# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
+		extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
+	fi
 	if [ "${pahole_ver}" -ge "121" ]; then
 		extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
 	fi
_
