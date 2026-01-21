Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC6B364EA4
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966607; cv=none; b=o3THoSUYMjOd3PLPMtaXjeCSQAnYqOA5JlcRCG4bDkfUzF2M9zjPwqVyA8GkOORutmW51c111pjrwJkTC+pqUSVw1AF92RqTHMg7xsFvecB1xIQstpWDovYZFrAGUMDeoCvidcaRVO5SlokRDsTascF0YfVH8Sns8o6WdcCMEjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966607; c=relaxed/simple;
	bh=zeiPKERdwgmnkrrtetPaMYmJ5x1pjF6qj+pP2VDaO6U=;
	h=Date:To:From:Subject:Message-Id; b=bZ4LzwYpnNOmGD2dny3joFC0UwkZ+n+RgJGdYfwjwDJlZg3EFVhmEPb5DxyBR2ROXz7WyCUupithH2uiMJsMLRCiEFymBkfYIxc/oQCbBtmku4NU5MQKgGyWY4b+oJ7J/Ouu1S9hhjlhogPNxjJxD8WztvElGE/zoUXwmWjRDZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NoR7QSib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NoR7QSib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E3DC16AAE;
	Wed, 21 Jan 2026 03:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966607;
	bh=zeiPKERdwgmnkrrtetPaMYmJ5x1pjF6qj+pP2VDaO6U=;
	h=Date:To:From:Subject:From;
	b=NoR7QSibRmXtntywmYl9AxF87aIjyqlnbeoLHCVIvYb7XEbI9VKVSYRwuO0zzeS+r
	 +LOgQ84qXEI2tcwCDQY/kv0HeBm3EjvS7/BwpihFkLku26iLBdqzDLnmohMyAQRSDZ
	 eHrJJryhF6sLWa0QiOZlA/tY19ootWP/tAQovYxg=
Date: Tue, 20 Jan 2026 19:36:46 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-abi-add-memblock-abi-header-fix.patch removed from -mm tree
Message-Id: <20260121033647.02E3DC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: adjust file entry in MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
has been removed from the -mm tree.  Its filename was
     kho-abi-add-memblock-abi-header-fix.patch

This patch was dropped because it was folded into kho-abi-add-memblock-abi-header.patch

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: MAINTAINERS: adjust file entry in MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
Date: Wed, 7 Jan 2026 10:04:38 +0100

Commit e8d87911a204 ("kho/abi: add memblock ABI header") removes the files
in Documentation/core-api/kho/bindings/memblock/ and adds the
corresponding content in include/linux/kho/abi/memblock.h, but misses to
adjust the file entry in the MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
section of the MAINTAINERS file.

Adjust the file entry in accordance with the changes of the commit above.

Link: https://lkml.kernel.org/r/20260107090438.22901-1-lukas.bulwahn@redhat.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~kho-abi-add-memblock-abi-header-fix
+++ a/MAINTAINERS
@@ -16397,7 +16397,7 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
 F:	Documentation/core-api/boot-time-mm.rst
-F:	Documentation/core-api/kho/bindings/memblock/*
+F:	include/linux/kho/abi/memblock.h
 F:	include/linux/memblock.h
 F:	mm/bootmem_info.c
 F:	mm/memblock.c
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are

kho-abi-add-memblock-abi-header.patch

