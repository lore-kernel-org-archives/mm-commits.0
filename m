Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B032DC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB742177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781056;
	bh=D0gGW7zN6emYU3ITObP13wLCAJvpfiCO+L9kgcJ1wCg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jUib3+ydPUz2MH5COAcJONJdV5hbhjUHbPA9lwsCj5M5p8h+QInPPlYZotk8s2jSk
	 iCjUpf982lV3EU1PAmrFzEtv+6A16eIqiRFwp0+uu1Xtm99S1P1VBQi0wlDxRXlgeb
	 hFmgso6x5zyJVAO2Ao+LTJgJltl/9NfMLVTFQRTk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGGRg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CAF822C9F;
        Fri,  7 Aug 2020 06:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781055;
        bh=D0gGW7zN6emYU3ITObP13wLCAJvpfiCO+L9kgcJ1wCg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PKsFyyONcslj0FyYxSkmE+8iGdg1BuDwH7mqGX8SpL44WatKNLzCazBBy3miGxwPW
         LmBeAufIk5Xp7hr0PrYoc5SlPyFkvvqJVPnu1DXP/Q2jThsXIGujfK0J7pMyR9WKLj
         MX4aiJqrSjcdUdqsUwh5M/coLMGhZAT9xe5RwpqM=
Date:   Thu, 06 Aug 2020 23:17:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, khlebnikov@yandex-team.ru,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sashal@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 010/163] scripts/decode_stacktrace.sh: skip
 missing symbols
Message-ID: <20200807061735.tb6sJM1z7%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: scripts/decode_stacktrace.sh: skip missing symbols

For now script turns missing symbols into '0' and make bogus decode.  Skip
them instead.  Also simplify parsing output of 'nm'.

Before:

$ echo 'xxx+0x0/0x0' | ./scripts/decode_stacktrace.sh vmlinux ""
xxx (home/khlebnikov/src/linux/./arch/x86/include/asm/processor.h:398)

After:

$ echo 'xxx+0x0/0x0' | ./scripts/decode_stacktrace.sh vmlinux ""
xxx+0x0/0x0

Link: http://lkml.kernel.org/r/159282922499.248444.4883465570858385250.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-skip-missing-symbols
+++ a/scripts/decode_stacktrace.sh
@@ -56,7 +56,11 @@ parse_symbol() {
 	if [[ "${cache[$module,$name]+isset}" == "isset" ]]; then
 		local base_addr=${cache[$module,$name]}
 	else
-		local base_addr=$(nm "$objfile" | grep -i ' t ' | awk "/ $name\$/ {print \$1}" | head -n1)
+		local base_addr=$(nm "$objfile" | awk '$3 == "'$name'" && ($2 == "t" || $2 == "T") {print $1; exit}')
+		if [[ $base_addr == "" ]] ; then
+			# address not found
+			return
+		fi
 		cache[$module,$name]="$base_addr"
 	fi
 	# Let's start doing the math to get the exact address into the
_
