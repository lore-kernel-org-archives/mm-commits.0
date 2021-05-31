Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EFAC47080
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 22:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAB516135C
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 22:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhEaWSl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 18:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231305AbhEaWSl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 18:18:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B911C61287;
        Mon, 31 May 2021 22:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622499421;
        bh=iCR/pb7mbOG3ov24g5041hJ8qvpOkJPjlZV6EevGOgA=;
        h=Date:From:To:Subject:From;
        b=ZMXPWESe2eWJ8tj3XmCZh/p6u7asbn8/wyOCPK0HzWUDsBzgh8CT7a98FA04xYiTi
         SWE64WDm6t2UuAtSG+E4r7YfoqV2oSStGK3COEfTTCL1uO8hwsa0Igw+Kna9SyhQPo
         T0AUlqZxRgbR5zcO6aRTC0Y94Hhj2Fe5aYAav8vo=
Date:   Mon, 31 May 2021 15:17:00 -0700
From:   akpm@linux-foundation.org
To:     acme@redhat.com, andrii@kernel.org, haoluo@google.com,
        jolsa@kernel.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, msuchanek@suse.de
Subject:  +
 kbuild-skip-per-cpu-btf-generation-for-pahole-v118-v121.patch added to -mm
 tree
Message-ID: <20210531221700.bpHuPUPFy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21
has been added to the -mm tree.  Its filename is
     kbuild-skip-per-cpu-btf-generation-for-pahole-v118-v121.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kbuild-skip-per-cpu-btf-generation-for-pahole-v118-v121.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kbuild-skip-per-cpu-btf-generation-for-pahole-v118-v121.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from andrii@kernel.org are

kbuild-skip-per-cpu-btf-generation-for-pahole-v118-v121.patch

