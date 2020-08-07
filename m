Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C859C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F69C2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779025;
	bh=GDgerawtW5HShlH01bCMugpWUYY5/CBrzo4NHkQZV4I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uAxuviz0phuqauY16BomQaRDS5UJ9V/+f4q8sAfWVyDzh8i4/grLO6EgJ/HIkiKef
	 rx5RDiQSyBI3/Zyh+zEP+rUripxU/veu4JWskC5+fdW7zrxYhloIj5uxIkhUZTQ2Ci
	 WC+oarHuEAXP/mLWE+/LovHdVr9yQLR3OQpI5U3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgHGFno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFno (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:43:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8D0120855;
        Fri,  7 Aug 2020 05:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779024;
        bh=GDgerawtW5HShlH01bCMugpWUYY5/CBrzo4NHkQZV4I=;
        h=Date:From:To:Subject:From;
        b=kz28aTM7okYv+3rXGa+YM4NJym/tJHDBMgWRCWmDgkbM/0/ZGBNK3tTCcBUWjP46L
         WHHnhCUQm25VEXYi3DdFQWIy38F9mhlKf0RXov1WcWn3PTDxyi4vOLHomNs/p9ZKas
         Qso40g3gN9WHTrwnuitp2FN86NF6nrRnCftPaVgQ=
Date:   Thu, 06 Aug 2020 22:43:43 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, gregkh@linuxfoundation.org, joe@perches.com,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, xujialu@vimux.org
Subject:  [folded-merged]
 scripts-tagssh-collect-compiled-source-precisely-v2.patch removed from -mm
 tree
Message-ID: <20200807054343.ibO4XhS7P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-tagssh-collect-compiled-source-precisely-v2
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-collect-compiled-source-precisely-v2.patch

This patch was dropped because it was folded into scripts-tagssh-collect-compiled-source-precisely.patch

------------------------------------------------------
From: Jialu Xu <xujialu@vimux.org>
Subject: scripts-tagssh-collect-compiled-source-precisely-v2

don't expand symlinks by add option -s for realpath

Link: http://lkml.kernel.org/r/5efc5bfb.1c69fb81.41bf5.7131SMTPIN_ADDED_MISSING@mx.google.com
Signed-off-by: Jialu Xu <xujialu@vimux.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/tags.sh~scripts-tagssh-collect-compiled-source-precisely-v2
+++ a/scripts/tags.sh
@@ -91,7 +91,7 @@ all_sources()
 
 all_compiled_sources()
 {
-	realpath -e $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
+	realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
 		include/generated/autoconf.h $(find -name "*.cmd" -exec \
 		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
 		awk '!a[$0]++') | sort -u
_

Patches currently in -mm which might be from xujialu@vimux.org are

scripts-tagssh-collect-compiled-source-precisely.patch

