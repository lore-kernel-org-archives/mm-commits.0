Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FDE4C79;
	Fri, 20 Jun 2025 00:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750380762; cv=none; b=smQikOwq3UBEnhbL3pyZFeSEvwNckPagsltpKwogyNxO7f3byAJm8iwco2weGjt/ku3pNRvlNaY9B0kguVSV2JvavI8BFCrr1JGDGzlOusTyp4XN/Nu/koF1Eech6V+jEJZ1x7SuWi892BpuG8N+1vCKcl0fhoBojl6g2L3Nuxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750380762; c=relaxed/simple;
	bh=oeXTHW5s1DfLw9fG/pnWky8fl0iX2hToNEWrDJh8dnI=;
	h=Date:To:From:Subject:Message-Id; b=dzAjzzBHehCibm2wZn2M0In7JZ+DUHCcRKZkbnvaqfR4ujvCQcfjHM427jfm/7Up27JuTJpiGXKX/3MmQkXRsj784fQN/wU3YOv/UdedcDmDM7gDrIADTr20pN/sziP/jfADB6kBtfEBwzpIe6Utmw1Y398zfUaYXhtklw9RqiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WNa2n9XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WNa2n9XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D910C4CEEA;
	Fri, 20 Jun 2025 00:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750380762;
	bh=oeXTHW5s1DfLw9fG/pnWky8fl0iX2hToNEWrDJh8dnI=;
	h=Date:To:From:Subject:From;
	b=WNa2n9XExVI2nZ4qbAfXPgFze5950pzWp88kDq4m7xPzyvvwiDK64K7tQNw/eCbu7
	 mxsYDeoHV2QJr2aDqYOatLS5+jv69ECezSo+1KfzjYdJDOlLbVsnJUK/VKQ6CNRj3E
	 FHBg2uAypWe4Ub0TefXBZqXVy/GBFejG/pgb4jJk=
Date: Thu, 19 Jun 2025 17:52:41 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,kbingham@kernel.org,jlayton@kernel.org,jan.kiszka@siemens.com,jack@suse.cz,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-dentry_name-lookup.patch added to mm-hotfixes-unstable branch
Message-Id: <20250620005242.3D910C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix dentry_name() lookup
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-fix-dentry_name-lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-dentry_name-lookup.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Florian Fainelli <florian.fainelli@broadcom.com>
Subject: scripts/gdb: fix dentry_name() lookup
Date: Thu, 19 Jun 2025 15:51:05 -0700

The "d_iname" member was replaced with "d_shortname.string" in the commit
referenced in the Fixes tag.  This prevented the GDB script "lx-mount"
command to properly function:

(gdb) lx-mounts
      mount          super_block     devname pathname fstype options
0xff11000002d21180 0xff11000002d24800 rootfs / rootfs rw 0 0
0xff11000002e18a80 0xff11000003713000 /dev/root / ext4 rw,relatime 0 0
Python Exception <class 'gdb.error'>: There is no member named d_iname.
Error occurred in Python: There is no member named d_iname.

Link: https://lkml.kernel.org/r/20250619225105.320729-1-florian.fainelli@broadcom.com
Fixes: 58cf9c383c5c ("dcache: back inline names with a struct-wrapped array of unsigned long")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/vfs.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/vfs.py~scripts-gdb-fix-dentry_name-lookup
+++ a/scripts/gdb/linux/vfs.py
@@ -22,7 +22,7 @@ def dentry_name(d):
     if parent == d or parent == 0:
         return ""
     p = dentry_name(d['d_parent']) + "/"
-    return p + d['d_iname'].string()
+    return p + d['d_shortname']['string'].string()
 
 class DentryName(gdb.Function):
     """Return string of the full path of a dentry.
_

Patches currently in -mm which might be from florian.fainelli@broadcom.com are

scripts-gdb-fix-dentry_name-lookup.patch

