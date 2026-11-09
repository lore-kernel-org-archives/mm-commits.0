Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794203491;
	b=rcOHsTKqnWdlYJuUcOmVN8LQycM5p6pjG7Ahy+6me+aF18XQmpf9ee800J567ktkIx81
	 XNnqgBzSWCY7OX0AxBJb1YfPv+Dphht53+eIesH6KNBY60T8clt13HA/1F9AjymA6W3W6
	 d4kchpYTgWzD1V96Wq/DhMW89ycFQZ7V932JIrkjPu4vZM7k2QOhVTW3viJpjImVvLm8t
	 VwlVrWgIa8Y5BEnpVgDEBqBUNBlstE1Np+ORUUu3GTw5PKyE0qdKTleb5TfyzMdA8DuyD
	 wlSf6KIfm9P2FU33hQJJSTisBkzfSu/fd74kVrEd8pPpBNJyNTNdtWJPnLQgp4qeMfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794203491;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kONOIuso2Mrr6CuuLEONMZhG3ZY7XOMBXHuBsE50H5c=;
	b=tpqP7UZQWwZnElKv2PSCVP7i3QgucfMbfmcVRnIKBXtmyrtIEI9Y9J7IisG3CP2f09Fo
	 9e3gQwQz39y491CmoDuZdsmMhR8yotIsK9fBCyjc5dNr09UuVQoyX+kEEPFJh+8XMzo8V
	 B65WMTj4SzKyyyr6WurnQcifNwibiGaPdL1oDI5GZSENKo5aWg6qUZRmeyhIktCybLc0U
	 ZPgFFZIJSNaPv+byXpIoXRyqFMuocu5E07RV8SJmGccP7gbY2Va62FRl5pymHNvc3dfaA
	 DndUnGmLLRnakhvf/f4Z/Ucmo0cPHV3MSYHL4goR3hTfeMCyowqKuDi7JkWZGWbkz1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=URKVROu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EF2606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 05:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=URKVROu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568AB1F0089F;
	Mon,  9 Nov 2026 05:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794203490;
	bh=kONOIuso2Mrr6CuuLEONMZhG3ZY7XOMBXHuBsE50H5c=;
	h=Date:To:From:Subject;
	b=URKVROu81aghr7tzwylrhInh5JLecmUXnH7obXVvYZcCSnRWmWWojZ3wqa/DhM7Ex
	 8+UJQV9G0HhaGxL1cMGh5Flxurg+cjv5M80+9nc/6amfKJ04mhZTcyrKUHO7KQgLXF
	 dPS/t0rD+IKgIX4iyYPS9nHfOry0gUfdJ4Cxs/HY=
Date: Sun, 08 Nov 2026 21:51:29 -0800
To: mm-commits@vger.kernel.org,joe@perches.com,apw@canonical.com,
	ptosi@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-fix-bad-file_path_changes-on-headers.patch added to mm-nonmm-unstable branch
Message-Id: <20261109055130.568AB1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: checkpatch: fix bad FILE_PATH_CHANGES on headers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-fix-bad-file_path_changes-on-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-fix-bad-file_path_changes-on-headers.patch

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
From: Pierre-Clément Tosi <ptosi@google.com>
Subject: checkpatch: fix bad FILE_PATH_CHANGES on headers
Date: Sat, 07 Nov 2026 16:02:36 +0100

The FILE_PATH_CHANGES warning ("added, moved or deleted file(s), does
MAINTAINERS need updating?") added by commit 13f1937ef339 ("checkpatch:
emit a warning on file add/move/delete") was guarded by !$in_commit_log so
that commit message lines would not be mistaken for diffstat or diff
header lines.

However, it was still evaluated on the initial email header lines
($in_header_lines == 1) such that a title using the rename notation e.g.

    Subject: [PATCH] foo: rework bar_{get=>set}_baz()

triggers a false-positive warning. Furthermore, that same (wrong) code
path sets $is_patch prematurely.

Instead, only test for FILE_PATH_CHANGES when !$in_header_lines.

Link: https://lore.kernel.org/20261107-checkpatch-file_path_changes-v1-1-8b11814560d8@google.com
Fixes: 13f1937ef339 ("checkpatch: emit a warning on file add/move/delete")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-bad-file_path_changes-on-headers
+++ a/scripts/checkpatch.pl
@@ -3486,7 +3486,7 @@ sub process {
 		}
 
 # Check for added, moved or deleted files
-		if (!$reported_maintainer_file && !$in_commit_log &&
+		if (!$reported_maintainer_file && !$in_commit_log && !$in_header_lines &&
 		    ($line =~ /^(?:new|deleted) file mode\s*\d+\s*$/ ||
 		     $line =~ /^rename (?:from|to) [\w\/\.\-]+\s*$/ ||
 		     ($line =~ /\{\s*([\w\/\.\-]*)\s*\=\>\s*([\w\/\.\-]*)\s*\}/ &&
_

Patches currently in -mm which might be from ptosi@google.com are

checkpatch-fix-bad-file_path_changes-on-headers.patch

