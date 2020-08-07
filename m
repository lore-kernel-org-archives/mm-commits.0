Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4173C433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEA2A22CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781050;
	bh=0J8e97K1uRmENcQYlqcoiBYrSlHuFNGoRr9491BvVWU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=TqBMcAxknRf9FEu43ZSEz0/nWPERXItii+SCCC46pDkxLjsD+IikJMYhGDg2ihM95
	 tE1VadKbTYwRy20/ymcy5QzVwZwqMZd/hkFDhh1mWzukoZiP1n85CRv6bfJz0GR9qW
	 l4TG91/s5RK2Ue5DTIhap5Hm/SReAYU9C5hmldMo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGGRa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 914772177B;
        Fri,  7 Aug 2020 06:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781050;
        bh=0J8e97K1uRmENcQYlqcoiBYrSlHuFNGoRr9491BvVWU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=siHRymgqrQI3/p432q2Wba/dxbv7a/wUhFwpAnwMvW3zqYZcAClxLtdU469p6ZqOj
         NvUbfOnpuME8/H/fumfWAdmQv5JBZZJosgXuyqRsNycRYIxyzJKou6YziEov9c9KSc
         Hs6jHzmMwHZ7mbOQjlFPzRotGxHMuJ9m9JR4fYec=
Date:   Thu, 06 Aug 2020 23:17:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, joe@perches.com, linux-mm@kvack.org,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        xujialu@vimux.org
Subject:  [patch 008/163] scripts/tags.sh: collect compiled source
 precisely
Message-ID: <20200807061729.OFb0Kw9sM%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jialu Xu <xujialu@vimux.org>
Subject: scripts/tags.sh: collect compiled source precisely

Parse compiled source from *.cmd but don't 'find' too many files that are
not related to compilation.

[xujialu@vimux.org: don't expand symlinks by add option -s for realpath]
  Link: http://lkml.kernel.org/r/5efc5bfb.1c69fb81.41bf5.7131SMTPIN_ADDED_MISSING@mx.google.com
Link: http://lkml.kernel.org/r/5ee5d8e3.1c69fb81.9b804.47b2SMTPIN_ADDED_MISSING@mx.google.com
Signed-off-by: Jialu Xu <xujialu@vimux.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/scripts/tags.sh~scripts-tagssh-collect-compiled-source-precisely
+++ a/scripts/tags.sh
@@ -91,20 +91,10 @@ all_sources()
 
 all_compiled_sources()
 {
-	for i in $(all_sources); do
-		case "$i" in
-			*.[cS])
-				j=${i/\.[cS]/\.o}
-				j="${j#$tree}"
-				if [ -e $j ]; then
-					echo $i
-				fi
-				;;
-			*)
-				echo $i
-				;;
-		esac
-	done
+	realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
+		include/generated/autoconf.h $(find -name "*.cmd" -exec \
+		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
+		awk '!a[$0]++') | sort -u
 }
 
 all_target_sources()
_
