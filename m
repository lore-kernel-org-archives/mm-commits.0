Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC23C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B52E2087C
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927963;
	bh=nF1EdkbVG3W5/hQKbVjki4tVVGazg4HD7T8TQwO2g/8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=B4faomenlB1MDu8eEztM+wSBv+C1rvhwDvKwily9MFEJNO9+TKsvhcnDgPnZvDOhR
	 FxITj4URNEvPL4XSrP81JDEURIELeKjPFZIuF1ierxYhYBkZDbR5+aesKEt49PFOhb
	 O/JdDZ+peVaqnEQOg4CKqUz1QiSZmGrFRfHkAu/I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgILQ0B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgILQYq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:24:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97049221E5;
        Sat, 12 Sep 2020 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927859;
        bh=nF1EdkbVG3W5/hQKbVjki4tVVGazg4HD7T8TQwO2g/8=;
        h=Date:From:To:Subject:From;
        b=Fs6QIMRH0TRvlPc40Dvo+7+eDw+0PB6jrtVTjIcRZv0uGYuYhGZehvGntZLxgu9VN
         0QvgvzLYz/23oVO4P7KnOHSgBiY2m0Wypk9w4Jy0a0KS4N2odLd3uBpF06cTIIFgvs
         B4jI0nIrRpnOjR3d+pGu5jBz3rjsM/4lcvDJ8hdI=
Date:   Sat, 12 Sep 2020 09:24:19 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, gregkh@linuxfoundation.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, rkovhaev@gmail.com, xujialu@vimux.org
Subject:  [merged]
 scripts-tagssh-exclude-tools-directory-from-tags-generation.patch removed
 from -mm tree
Message-ID: <20200912162419.tSaqOPM53%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: exclude tools directory from tags generation
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-exclude-tools-directory-from-tags-generation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rustam Kovhaev <rkovhaev@gmail.com>
Subject: scripts/tags.sh: exclude tools directory from tags generation

When COMPILED_SOURCE is set, running 'make ARCH=x86_64 COMPILED_SOURCE=1
cscope tags' in KBUILD_OUTPUT directory produces lots of "No such file or
directory" warnings:

...
realpath: sigchain.h: No such file or directory
realpath: orc_gen.c: No such file or directory
realpath: objtool.c: No such file or directory
...

Let's exclude tools directory from tags generation

Link: https://lkml.kernel.org/r/20200810153650.1822316-1-rkovhaev@gmail.com
Link: https://lore.kernel.org/lkml/20200809210056.GA1344537@thinkpad
Fixes: 4f491bb6ea2a ("scripts/tags.sh: collect compiled source precisely")
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jialu Xu <xujialu@vimux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/scripts/tags.sh~scripts-tagssh-exclude-tools-directory-from-tags-generation
+++ a/scripts/tags.sh
@@ -26,7 +26,11 @@ else
 fi
 
 # ignore userspace tools
-ignore="$ignore ( -path ${tree}tools ) -prune -o"
+if [ -n "$COMPILED_SOURCE" ]; then
+	ignore="$ignore ( -path ./tools ) -prune -o"
+else
+	ignore="$ignore ( -path ${tree}tools ) -prune -o"
+fi
 
 # Detect if ALLSOURCE_ARCHS is set. If not, we assume SRCARCH
 if [ "${ALLSOURCE_ARCHS}" = "" ]; then
@@ -92,7 +96,7 @@ all_sources()
 all_compiled_sources()
 {
 	realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
-		include/generated/autoconf.h $(find -name "*.cmd" -exec \
+		include/generated/autoconf.h $(find $ignore -name "*.cmd" -exec \
 		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
 		awk '!a[$0]++') | sort -u
 }
_

Patches currently in -mm which might be from rkovhaev@gmail.com are

ntfs-add-check-for-mft-record-size-in-superblock.patch

