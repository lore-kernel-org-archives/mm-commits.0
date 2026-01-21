Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3C635B158
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967371; cv=none; b=bcI0/H7k+m5GzvS9ssnQaBr6rxC/Rxb1F59H6OpWFdrCueL8OQ+5ZrbNh6xcHMI9zMVnBHBsCX+lpVkroF+UPTviWq20qKVgIANA0B9NmIiA2bcl3avonUnSAK4QzHDCyNLDseAS+9X3OgftgFvRCNi+JOd6M6slyQcGQzlB0LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967371; c=relaxed/simple;
	bh=A0pLNqL7J4ecUXI5DPw2pUbQdh9NfVen3+JSVwoCMHI=;
	h=Date:To:From:Subject:Message-Id; b=CKm3FX+sjOUBsjPXECC0N6YNbEn1E9XbQ39QxSfyTJjKjBenTkL5/TKNJDyAbxYOjwtRYfOKb5iGzdarCpl5xnu0obmz8YqkY/DyAZsF416Tv49OznM0cNaGldZNDmzoKFMrUg/plpvX+sJpGWfPs9tMPPRlClNPgNj2m7ELAOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GKjqtMf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GKjqtMf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3ACC19423;
	Wed, 21 Jan 2026 03:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967371;
	bh=A0pLNqL7J4ecUXI5DPw2pUbQdh9NfVen3+JSVwoCMHI=;
	h=Date:To:From:Subject:From;
	b=GKjqtMf9eqtxjIGjIfuzs8RWciHJDA5Nq5sdVxbLf3KXXoGrYR8tlUAK1E9ll0J+O
	 0eoR1l2iWkbqB/O/ZvBL3+eJkrCpQFR15YT43LikwTiNxgW8KLn+kK2PGkvlrnHDkA
	 YSWAXdupHhQuBuQ7R97h7rfQhknV2W8/Msj8NEds=
Date: Tue, 20 Jan 2026 19:49:30 -0800
To: mm-commits@vger.kernel.org,arnd@arndb.de,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] types-drop-definition-of-__exported_headers__.patch removed from -mm tree
Message-Id: <20260121034931.1F3ACC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: types: drop definition of __EXPORTED_HEADERS__
has been removed from the -mm tree.  Its filename was
     types-drop-definition-of-__exported_headers__.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: types: drop definition of __EXPORTED_HEADERS__
Date: Tue, 30 Dec 2025 08:13:15 +0100

This definition disarms the warning in uapi/linux/types.h about including
kernel headers from user space.  However the warning is already disarmed
due to the fact that kernel code is built with -D__KERNEL__.

Drop the pointless definition.

Link: https://lkml.kernel.org/r/20251230-exported-headers-types-h-v1-1-947fc606f3d8@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/types.h~types-drop-definition-of-__exported_headers__
+++ a/include/linux/types.h
@@ -2,7 +2,6 @@
 #ifndef _LINUX_TYPES_H
 #define _LINUX_TYPES_H
 
-#define __EXPORTED_HEADERS__
 #include <uapi/linux/types.h>
 
 #ifndef __ASSEMBLY__
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are


