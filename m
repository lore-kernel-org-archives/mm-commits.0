Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251A7C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjBCGmu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjBCGl2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E5930C3
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9641461DAB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94F0C433EF;
        Fri,  3 Feb 2023 06:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406280;
        bh=BwMlw1aMRnQZR69ghGuqyCV7yEu6fMHNDbOPseTotyY=;
        h=Date:To:From:Subject:From;
        b=k0x/9JLLBmFPtDotgXBvPxPSGVNCwyes770RvZHOtQ6yHlCM5zcgkZngFeVSyNgNu
         72hjzlueE2DQGcAiXBl+vRfRgJBx/pCcbfAj2fvxw7vzMfipXgGvD6S0UuIa0Mc92a
         pXjln3GQnQKMruCmlDwGFjMZcEW2aBRlqvOGjdhA=
Date:   Thu, 02 Feb 2023 22:37:59 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, scweaver@redhat.com,
        jforbes@redhat.com, dzickus@redhat.com, herton@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-vm-allow-users-to-provide-additional-cflags-ldflags.patch removed from -mm tree
Message-Id: <20230203063759.E94F0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/mm: allow users to provide additional cflags/ldflags
has been removed from the -mm tree.  Its filename was
     tools-vm-allow-users-to-provide-additional-cflags-ldflags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Herton R. Krzesinski" <herton@redhat.com>
Subject: tools/mm: allow users to provide additional cflags/ldflags
Date: Mon, 16 Jan 2023 19:49:21 -0300

Right now there is no way to provide additional cflags/ldflags when
building tools/vm binaries.  And using eg.  make CFLAGS=<options> will
override the CFLAGS being set in the Makefile, making the build fail since
it requires the include of the ../lib dir (for libapi).

This change then allows you to specify:
CFLAGS=<options> LDFLAGS=<options> make V=1 -C tools/vm

And the options will be correctly appended as can be seen from the
make output.

Link: https://lkml.kernel.org/r/20230116224921.4106324-1-herton@redhat.com
Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Justin Forbes <jforbes@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Scott Weaver <scweaver@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/mm/Makefile~tools-vm-allow-users-to-provide-additional-cflags-ldflags
+++ a/tools/mm/Makefile
@@ -8,8 +8,8 @@ TARGETS=page-types slabinfo page_owner_s
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
 
-CFLAGS = -Wall -Wextra -I../lib/
-LDFLAGS = $(LIBS)
+CFLAGS += -Wall -Wextra -I../lib/
+LDFLAGS += $(LIBS)
 
 all: $(TARGETS)
 
_

Patches currently in -mm which might be from herton@redhat.com are


