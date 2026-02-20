Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F30B672
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 03:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771557530; cv=none; b=I2USEdRMDz7c7fax1YO7R2H96JHx/A2L1QOESO8olctcKMbuCBXi1b6zGnNGmFvVfGPf7azZfon8AxiD3XlZ3ElL63mpEZQLTofbgYxtr8sJBbtAaGQP2N23pOsl+d8UA42FbuQnd95rPFpMpAcNDvHkav5g6j/TlPxpaCu2kns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771557530; c=relaxed/simple;
	bh=53NbWi22HflW00CdiCo61LF5Y7IvnbEQzaakFf9NocE=;
	h=Date:To:From:Subject:Message-Id; b=MOK6OjoBXUhfOGIHVRyB6ardvAQAv+6HQLDxIcD/+vZAzSu+ziH9ySgU1+Q3H9IRxBaHCwBBgQCGVhn4H3lN6p6MROJPdiefChyHDCNUinTNWpAT1TN2T/dscTqIYfHBfMwaTk7Rj7PWXi7jVpXOkz7bDRG3d0aYV20f2Bi69cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xLu5seEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xLu5seEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB06C4CEF7;
	Fri, 20 Feb 2026 03:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771557530;
	bh=53NbWi22HflW00CdiCo61LF5Y7IvnbEQzaakFf9NocE=;
	h=Date:To:From:Subject:From;
	b=xLu5seEXtwlgGhF9Wr4Jx5H9CXWL96NDevVL3ypjWmtzNpTBJfxhJfgTdAZtek1Ij
	 PslrDClCwWyvQR0L7mS9ZlU20VQpDDfqeC68Tcq3vMHtlBmi6nLc5mSrT1hpJlH9e4
	 yNshe/KjWAGyI644auBqUtD8mUJKTByrAuEX4DIc=
Date: Thu, 19 Feb 2026 19:18:49 -0800
To: mm-commits@vger.kernel.org,vkoskiv@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-bloat-o-meter-rename-file-arguments-to-match-output.patch added to mm-nonmm-unstable branch
Message-Id: <20260220031850.4CB06C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/bloat-o-meter: rename file arguments to match output
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-bloat-o-meter-rename-file-arguments-to-match-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-bloat-o-meter-rename-file-arguments-to-match-output.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Valtteri Koskivuori <vkoskiv@gmail.com>
Subject: scripts/bloat-o-meter: rename file arguments to match output
Date: Thu, 12 Feb 2026 23:39:33 +0200

The output of bloat-o-meter already uses the words 'old' and 'new' for
symbol size in the table header, so reflect that in the corresponding
argument names.

Link: https://lkml.kernel.org/r/20260212213941.3984330-1-vkoskiv@gmail.com
Signed-off-by: Valtteri Koskivuori <vkoskiv@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-rename-file-arguments-to-match-output
+++ a/scripts/bloat-o-meter
@@ -18,8 +18,8 @@ group.add_argument('-c', help='categoriz
 group.add_argument('-d', help='Show delta of Data Section', action='store_true')
 group.add_argument('-t', help='Show delta of text Section', action='store_true')
 parser.add_argument('-p', dest='prefix', help='Arch prefix for the tool being used. Useful in cross build scenarios')
-parser.add_argument('file1', help='First file to compare')
-parser.add_argument('file2', help='Second file to compare')
+parser.add_argument('file_old', help='First file to compare')
+parser.add_argument('file_new', help='Second file to compare')
 
 args = parser.parse_args()
 
@@ -86,7 +86,7 @@ def calc(oldfile, newfile, format):
 
 def print_result(symboltype, symbolformat):
     grow, shrink, add, remove, up, down, delta, old, new, otot, ntot = \
-    calc(args.file1, args.file2, symbolformat)
+    calc(args.file_old, args.file_new, symbolformat)
 
     print("add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
           (add, remove, grow, shrink, up, -down, up-down))
_

Patches currently in -mm which might be from vkoskiv@gmail.com are

scripts-bloat-o-meter-rename-file-arguments-to-match-output.patch

