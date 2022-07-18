Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7167C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiGRAdB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiGRAck (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D8C13EBD
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86ACB60FB0
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7185C3411E;
        Mon, 18 Jul 2022 00:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104358;
        bh=NR/s9AI+qOZfZD/r8A/OGNq7zr8YTYJ3J6shd71R0Qw=;
        h=Date:To:From:Subject:From;
        b=QeRrPbDjYQh8ei/fqiSApUBNniCp0BiE7wGutMC+ZFhCYz5+qJflcf15sDMTcaTaL
         PvDUrLEgY0AFrFfD1AQ8SD3JOFdncG06L9H5W1TXHLK6L8mETpotto0iBw5SujsoZ1
         2I5v0POnt2GXU/dNoqHiAEu7sQDsZfx3mBw+tcIA=
Date:   Sun, 17 Jul 2022 17:32:38 -0700
To:     mm-commits@vger.kernel.org, nborisov@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-bloat-o-meter-add-p-argument.patch removed from -mm tree
Message-Id: <20220718003238.D7185C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/bloat-o-meter: add -p argument
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-add-p-argument.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nikolay Borisov <nborisov@suse.com>
Subject: scripts/bloat-o-meter: add -p argument
Date: Fri, 1 Jul 2022 14:35:13 +0300

When doing cross platform development on a machine sometimes it might be
useful to invoke bloat-o-meter for files which haven't been build with the
native toolchain.  In cases when the host nm doesn't support the target
one then a toolchain-specific nm could be used.  Add this ability by
adding the -p allowing invocations as:

./scripts/bloat-o-meter -p riscv64-unknown-linux-gnu- file1.o file2.o

Link: https://lkml.kernel.org/r/20220701113513.1938008-2-nborisov@suse.com
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-add-p-argument
+++ a/scripts/bloat-o-meter
@@ -17,6 +17,7 @@ group = parser.add_mutually_exclusive_gr
 group.add_argument('-c', help='categorize output based on symbol type', action='store_true')
 group.add_argument('-d', help='Show delta of Data Section', action='store_true')
 group.add_argument('-t', help='Show delta of text Section', action='store_true')
+parser.add_argument('-p', dest='prefix', help='Arch prefix for the tool being used. Useful in cross build scenarios')
 parser.add_argument('file1', help='First file to compare')
 parser.add_argument('file2', help='Second file to compare')
 
@@ -26,7 +27,11 @@ re_NUMBER = re.compile(r'\.[0-9]+')
 
 def getsizes(file, format):
     sym = {}
-    with os.popen("nm --size-sort " + file) as f:
+    nm = "nm"
+    if args.prefix:
+        nm = "{}nm".format(args.prefix)
+
+    with os.popen("{} --size-sort {}".format(nm, file)) as f:
         for line in f:
             if line.startswith("\n") or ":" in line:
                 continue
_

Patches currently in -mm which might be from nborisov@suse.com are


