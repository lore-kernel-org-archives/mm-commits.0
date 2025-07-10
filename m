Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743E61A285;
	Thu, 10 Jul 2025 04:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120557; cv=none; b=CPBE1set287qpMPfiOt8iHPXjnCbW6Pr7Eh02FQ0ncx2HOI1G2Q7Bp8IwDqiFwNqSMMf2h6I/vcAYM1x7Iu7xpPvbrxpKdD9sQH4YXiQaztV2OUh0W7NinvC1GsAplAkJhdifAQX+8v90aVqj3z83SYFBa2TYNzcNbhYTGgXwb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120557; c=relaxed/simple;
	bh=H9bpp/k/lliP5XjvqDr5xvfHPTW1C78KwCjiT9in5OY=;
	h=Date:To:From:Subject:Message-Id; b=oDGnQ3m5cX1ULBT8vdWogUKYz5bEWeNmccdm0NYstjvnCMogrEGxq0755fZ9UQIlt7jIJ7nm35hB44dvoZFHDOY9Phh470mYt1vjYDqEEoYrgmx0ReZJRK6/yGI6RVTEo1BsXIcXRJ1RJNGIFEsYMf6HuJHRa8bu/SQ55RNtgOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B9tZhcvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B9tZhcvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40D5C4CEE3;
	Thu, 10 Jul 2025 04:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120557;
	bh=H9bpp/k/lliP5XjvqDr5xvfHPTW1C78KwCjiT9in5OY=;
	h=Date:To:From:Subject:From;
	b=B9tZhcvlVt/N8uHtJeqg+4Z4F185f+WpWhy9y7czMCcnIlefkJNomRDYdBro4z21V
	 B73TVbhGPfc9bwfzPLDueQb4oBJz+uxK9jT9MFhBmaNcFEHXqk/mksd/q6DRiBKGmx
	 BkIwUZTogDOtDJOHx/qWrLFSamdYVkjxDr4rI96s=
Date: Wed, 09 Jul 2025 21:09:16 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,jack@suse.cz,florian.fainelli@broadcom.com,brauner@kernel.org,illia@yshyn.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-vfs-support-external-dentry-names.patch removed from -mm tree
Message-Id: <20250710040916.E40D5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts: gdb: vfs: support external dentry names
has been removed from the -mm tree.  Its filename was
     scripts-gdb-vfs-support-external-dentry-names.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Illia Ostapyshyn <illia@yshyn.com>
Subject: scripts: gdb: vfs: support external dentry names
Date: Sun, 29 Jun 2025 02:38:11 +0200

d_shortname of struct dentry only reserves D_NAME_INLINE_LEN characters
and contains garbage for longer names.  Use d_name instead, which always
references the valid name.

Link: https://lore.kernel.org/all/20250525213709.878287-2-illia@yshyn.com/
Link: https://lkml.kernel.org/r/20250629003811.2420418-1-illia@yshyn.com
Fixes: 79300ac805b6 ("scripts/gdb: fix dentry_name() lookup")
Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/vfs.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/vfs.py~scripts-gdb-vfs-support-external-dentry-names
+++ a/scripts/gdb/linux/vfs.py
@@ -22,7 +22,7 @@ def dentry_name(d):
     if parent == d or parent == 0:
         return ""
     p = dentry_name(d['d_parent']) + "/"
-    return p + d['d_shortname']['string'].string()
+    return p + d['d_name']['name'].string()
 
 class DentryName(gdb.Function):
     """Return string of the full path of a dentry.
_

Patches currently in -mm which might be from illia@yshyn.com are


