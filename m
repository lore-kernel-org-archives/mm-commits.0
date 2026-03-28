Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5FD2DEA75
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671880; cv=none; b=pl8XjBFBBoWDPLEkhXtSFH8KmuVVUcqSXyhlmkYURYNpKkzlNEAJTJzCv30V8hn7rg4IWC7CoXAO5WhUlwuzuM6NcYgYWn0R1HMm19DLhuEt0tW5t0fwu/NluiMcHffTv1pfiXSRVG2yJz8lzDEsAvA2EJ0v7IkFZxbru82F4g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671880; c=relaxed/simple;
	bh=qRtbdrfgRZFi7tQQwvIodWmGkjdoJPyiy+8Ig3r5i0I=;
	h=Date:To:From:Subject:Message-Id; b=IbZBJ26u5tDZTdG+trYzrhYIGxAL1z2EOVHDm11+EYUj+u9KWZz+lG3gIzw2xaXg/fnIanImE76DpO/X77cjMJEcp+mnzgU1yuvzwuyTg832AXl2NscwXaal9TSjXwc5MBviGYlk6vmPlFcsF03Y1u3CVbICMCgeRb3Ny1uEdEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iilzb987; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iilzb987"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8356FC4CEF7;
	Sat, 28 Mar 2026 04:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671880;
	bh=qRtbdrfgRZFi7tQQwvIodWmGkjdoJPyiy+8Ig3r5i0I=;
	h=Date:To:From:Subject:From;
	b=Iilzb987HgfmUK0f/3+pyZNy7mXrv9x53s3Aw7IkxLz7BcruyaxAgbVyUpjOrBOT8
	 ND6T/4XlkF24QpbPwB/nP4iWNxHhVOUaktc/5go1dHkbtKWIjAC25hcRrSHBY26aKC
	 E3lY3cN2V7n6TrmIMyn0ZNf2QraMykFJbrDzA434=
Date: Fri, 27 Mar 2026 21:24:39 -0700
To: mm-commits@vger.kernel.org,vkoskiv@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-bloat-o-meter-rename-file-arguments-to-match-output.patch removed from -mm tree
Message-Id: <20260328042440.8356FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/bloat-o-meter: rename file arguments to match output
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-rename-file-arguments-to-match-output.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


