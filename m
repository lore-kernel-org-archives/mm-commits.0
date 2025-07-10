Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE92B286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127170; cv=none; b=AuDH4AjX0ORaLOqKiMGIz6oGd+guVzgE3jVRSaH9BiwKqECwaS0c42q0eYpucwKJ7pNkVxKy7ZzhdaZ/+EG/sbhek+S1ULs/6uKGlfI3iMIouP9aF9OOe1C0LSt9pNCTKnb8qlQW6gWrCoCujJ+8JGS7vX3bShsF2SmG2qAtL6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127170; c=relaxed/simple;
	bh=B1QJsWL9pk/gYE+U/gD0TA06i/7XQr+W1r6Hqo37p+0=;
	h=Date:To:From:Subject:Message-Id; b=RVuA1n0xQSJkA0rZ0YRbOkqD6yW7mfj7/pXEhuffO5DCndA8LiBFcJIMQC6A2RggvahmyWi3I+QvWXCwe0VWKgahKLjPAbpZl90MNtsGdApW17IgefcFOUuy5h2vRrvUOBgZm6Gd05GWL5G0qSVMMr52k2xsyUvAt8Rx1BRsd44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FkLCwwT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FkLCwwT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338C3C4CEE3;
	Thu, 10 Jul 2025 05:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127170;
	bh=B1QJsWL9pk/gYE+U/gD0TA06i/7XQr+W1r6Hqo37p+0=;
	h=Date:To:From:Subject:From;
	b=FkLCwwT0nVr3Rkb9J60Ka8jLHaUM4c9S3S9wQs9TfEjzobmjvxpPeOyrI5Y9d8whp
	 2VYH/4rY1Su1+TZDxW5mU4BIpE2a4nIOeIrJrPjH2xl4z/DhbvVVXVl9xHsVAwBjo+
	 i99roIwlmmqdvw9N3K40gxddcnI7RXiDJqxriY4w=
Date: Wed, 09 Jul 2025 22:59:29 -0700
To: mm-commits@vger.kernel.org,stephen.s.brennan@oracle.com,kbingham@kernel.org,jan.kiszka@siemens.com,benjamin.berg@intel.com,johannes.berg@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-move-mnt_-constants-to-gdb-parsed.patch removed from -mm tree
Message-Id: <20250710055930.338C3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts: gdb: move MNT_* constants to gdb-parsed
has been removed from the -mm tree.  Its filename was
     scripts-gdb-move-mnt_-constants-to-gdb-parsed.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: scripts: gdb: move MNT_* constants to gdb-parsed
Date: Wed, 18 Jun 2025 15:46:02 +0200

Since these are now no longer defines, but in an enum.

Link: https://lkml.kernel.org/r/20250618134629.25700-2-johannes@sipsolutions.net
Fixes: 101f2bbab541 ("fs: convert mount flags to enum")
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-move-mnt_-constants-to-gdb-parsed
+++ a/scripts/gdb/linux/constants.py.in
@@ -73,12 +73,12 @@ if IS_BUILTIN(CONFIG_MODULES):
     LX_GDBPARSED(MOD_RO_AFTER_INIT)
 
 /* linux/mount.h */
-LX_VALUE(MNT_NOSUID)
-LX_VALUE(MNT_NODEV)
-LX_VALUE(MNT_NOEXEC)
-LX_VALUE(MNT_NOATIME)
-LX_VALUE(MNT_NODIRATIME)
-LX_VALUE(MNT_RELATIME)
+LX_GDBPARSED(MNT_NOSUID)
+LX_GDBPARSED(MNT_NODEV)
+LX_GDBPARSED(MNT_NOEXEC)
+LX_GDBPARSED(MNT_NOATIME)
+LX_GDBPARSED(MNT_NODIRATIME)
+LX_GDBPARSED(MNT_RELATIME)
 
 /* linux/threads.h */
 LX_VALUE(NR_CPUS)
_

Patches currently in -mm which might be from johannes.berg@intel.com are


