Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE505C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1471206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026843;
	bh=dHIlSAXBsYxveWEPHP9VEGay3RjqFFK3LhlULdEXd9Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=W6JYCI1HX1lzRd72LbgtQak6ltxZs6+EZJLCIC2JT4UFUD/s+x0q1qWuKpBg3wGa+
	 iTKsdxgXFDkMeb+1gSni5UA/Zi+im8C8ytJ5SjbdJW7apBzOzKI6PguvReFktdjyS1
	 K4LA1s6LDJqpbl/Pbud142altQ03EnY0UU+CRXgY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgHJCeD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83877206CD;
        Mon, 10 Aug 2020 02:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026842;
        bh=dHIlSAXBsYxveWEPHP9VEGay3RjqFFK3LhlULdEXd9Q=;
        h=Date:From:To:Subject:From;
        b=ZEWrNfcAfqD80H7CLsKYJJAS222LJTZMisomMhcAJq+X/Yhr+4nVSuwvWSfPTDgCF
         oK3oRv6MbtJfneU7Hk50yYEmT8CrhG6EThi8Zu1Oe/Dbu7WZ/5AksGK6EaiCuSBlbo
         6xPjCE7nnrEbE4DACPgBInFV3M2yRzBW3sVeb2Lk=
Date:   Sun, 09 Aug 2020 19:34:02 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, gregkh@linuxfoundation.org, joe@perches.com,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, xujialu@vimux.org
Subject:  [merged]
 scripts-tagssh-collect-compiled-source-precisely.patch removed from -mm
 tree
Message-ID: <20200810023402.m19CdK4AV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: collect compiled source precisely
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-collect-compiled-source-precisely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from xujialu@vimux.org are


