Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4731F217707;
	Wed, 25 Jun 2025 22:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892159; cv=none; b=AL2Zo2hKTN9GG03fQoaWhNAi3BdC2ARKe1UEA79b/pG7NDtMl+2t+VIblWgtSJCMgyr6T2anTwdRWR4P5U0YHDR7Y9Qyt9H9wsg+oB0ivxndBkpYI4jT4Pv8CaGbfCrQrWrlcQUbUxa6MqivieLZmy7wsCIWlx8uDNVuJRVcZM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892159; c=relaxed/simple;
	bh=ecS3OAGSfbPms/mI5So+n7/c6aF7LLNkoaL7HaH6QGQ=;
	h=Date:To:From:Subject:Message-Id; b=UVeQJJHzONWvpCoRRXM2zzUm69Zggeh6+6cR+82/jeOFf0G9Y7UAtkubyemp3hHLK/WUOfqWFzkO17QL3E/PPvdTXReNRPwW7vfz5sUbyQOxoBhTLg+xzGHNkMXRmyGpl22pU9fgsLLjuyOYy0KL9ci99WfjaPVSMVv/mB4HOIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dpcHRuNh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dpcHRuNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9C8C4CEEA;
	Wed, 25 Jun 2025 22:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892159;
	bh=ecS3OAGSfbPms/mI5So+n7/c6aF7LLNkoaL7HaH6QGQ=;
	h=Date:To:From:Subject:From;
	b=dpcHRuNheDkS6zTyQ1UGC69VjPIoxL+HnVWGtzUTNWKbLAbR+6z9yLtqKtzV1VnGP
	 YcSKVSCdUKrPJO84Lar54giNVKBR9VFkuxec64D+Qwg/VmOOrUpYwx1VuxbSqeHXfP
	 A/78EiWmrSnkixvXJNw18Hh2ds+vg1jO9VsodT1M=
Date: Wed, 25 Jun 2025 15:55:58 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,kbingham@kernel.org,jlayton@kernel.org,jan.kiszka@siemens.com,jack@suse.cz,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-fix-dentry_name-lookup.patch removed from -mm tree
Message-Id: <20250625225559.1B9C8C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: fix dentry_name() lookup
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-dentry_name-lookup.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

scripts-gdb-fix-interrupts-display-after-mcp-on-x86.patch
scripts-gdb-fix-interruptspy-after-maple-tree-conversion.patch
scripts-gdb-de-reference-per-cpu-mce-interrupts.patch

