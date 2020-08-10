Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982B8C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E402073E
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026847;
	bh=slmRPo+ZTB1ZeImIZXOr6aVuRzImO40iNxMRMMil0GA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ll89uO/dhDynrMcC37LH6wMmLdSc4ywZOBNPjHK3sB1R138+V1jI+HbJ8S9giHg0N
	 OHej6TGdsZ5KbmBApyRTZTlTiN3Jz9yZV4Torko91TcAgaCLZi7j/JYFVyK2jjgg5U
	 94UeiL7xHRiWFaRSae8X37YSudd3twsmB4oOkM1w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHJCeH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E37C206E9;
        Mon, 10 Aug 2020 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026846;
        bh=slmRPo+ZTB1ZeImIZXOr6aVuRzImO40iNxMRMMil0GA=;
        h=Date:From:To:Subject:From;
        b=F+NXpCu3fiqYwTQtoG1WIFvPB7eqcrJ64E69MvDkHJvWfjbXYkGUiVHJyNlawNIhG
         CH1t/8BK36L2N1bQuHrjdHFirwV7smOcNyjXub4aaFos/AT2PDVqFmB6Z0K5U/j3Hp
         6d9jU70DBondbPXAGc8yeopVCH7UI7wZALjLKb6I=
Date:   Sun, 09 Aug 2020 19:34:06 -0700
From:   akpm@linux-foundation.org
To:     khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org,
        sashal@kernel.org
Subject:  [merged]
 scripts-decode_stacktrace-skip-missing-symbols.patch removed from -mm tree
Message-ID: <20200810023406.Lj_1TQNhf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace.sh: skip missing symbols
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktrace-skip-missing-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch

