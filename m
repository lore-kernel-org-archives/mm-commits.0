Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F5FC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7850208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816555;
	bh=brCt0qCHfkBhA9EqYNloJ/UWycXfoEpG9gxV2FQ2jrw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mj8KChGe7pvKmHmRyJto7fT/w1QHvItZszZgyRR4g3VkmGmTIvEcmepIFzv+FPQd5
	 macZuIc4nwzsMNkP/RSpVoJ6Mtrhw7LfrdwAHbhjj/673gtw6V1+utJ6IRV0s1FKnM
	 wJz1iha/mIMreQoxILCLoxoTUooCEhls3cMr9Bj4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404382AbgJPCtP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404364AbgJPCtP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:49:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E97B52087D;
        Fri, 16 Oct 2020 02:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816553;
        bh=brCt0qCHfkBhA9EqYNloJ/UWycXfoEpG9gxV2FQ2jrw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TPinKrb37OW+U0b9D1IKtCHPAMCRiWeF0nWD4SVsw5wwoCJC8aqHpCITp03W2+NyO
         +cb+Qcm+ygTvy1C/X1kITbXprRPqVS8RV+mDP2V67lAN74UV+WE1vJ0/nvg2zvdsUG
         8xcbb6wklEqkA/7IQwKRPCe6B1gWofRzvhLvu/c8=
Date:   Thu, 15 Oct 2020 19:49:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 130/156] checkpatch: emit a warning on embedded
 filenames
Message-ID: <20201016024911.qdfDRaUsY%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: emit a warning on embedded filenames

Embedding the complete filename path inside the file isn't particularly
useful as often the path is moved around and becomes incorrect.

Emit a warning when the source contains the filename.

[akpm@linux-foundation.org: remove stray " di"]
Link: https://lkml.kernel.org/r/1fd5f9188a14acdca703ca00301ee323de672a8d.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-emit-a-warning-on-embedded-filenames
+++ a/scripts/checkpatch.pl
@@ -3271,6 +3271,12 @@ sub process {
 			}
 		}
 
+# check for embedded filenames
+		if ($rawline =~ /^\+.*\Q$realfile\E/) {
+			WARN("EMBEDDED_FILENAME",
+			     "It's generally not useful to have the filename in the file\n" . $herecurr);
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|sh|dtsi|dts)$/);
 
_
