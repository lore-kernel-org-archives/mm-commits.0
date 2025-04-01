Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6DD21770C
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545916; cv=none; b=rWrbpv3rtx8DjB6tFxenRp+BOfQ7xTmDw5eNHBTVRZs7pebSGLEACp8wp4bEpUH5xGHT9Sb4ErDhQgJ9ekMZDHjYIqrze/lcFejYyYiGzboqnitW/5YVGNPfVq2HotNBuniW+XV83f2C0waNCxjpX//NAzCB7EdsfmOf61WFmJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545916; c=relaxed/simple;
	bh=GloQlUqlW2mINh2uSfaiWjs1iPQAHUALCBlXk2r2Qic=;
	h=Date:To:From:Subject:Message-Id; b=FkK13RbK43pmU8NPMKk8lkOQm1WwMI9ddHkaBgxOkBprov5PfhmSUA9tQRbjkpC+PoLvsfgP0LWY9NyHZrj4M5GSJLkLPLvP+BLiksY8Oiy1ni84vBaj07Ac6ujuWJMRm+fEXZRTH3UB5uF634U6twoBX9EIp3HIA3u8ij2sGO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MW080pPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MW080pPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC34C4CEE4;
	Tue,  1 Apr 2025 22:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545916;
	bh=GloQlUqlW2mINh2uSfaiWjs1iPQAHUALCBlXk2r2Qic=;
	h=Date:To:From:Subject:From;
	b=MW080pPbNDegv/RGSKIK3+BfmahUXzE5z1ewpCiZVZCeoWzHI+C0dJjWxiTWiynyI
	 ETcwLOlbBW3BzlqdHWQ/RlPQfp7BzvjHvrZpcmb3HYPgi8zsWYwxdiUKldb8YmmwKd
	 MNzU9Yf0ezjSv9dGCVUz3XrEwMasoVSyaA5X27ps=
Date: Tue, 01 Apr 2025 15:18:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.weissschuh@linutronix.de,sroettger@google.com,rientjes@google.com,rdunlap@infradead.org,peterx@redhat.com,pedro.falcato@gmail.com,oleg@redhat.com,ojeda@kernel.org,mpe@ellerman.id.au,mingo@kernel.org,mike.rapoport@gmail.com,mhocko@suse.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,Liam.Howlett@oracle.com,kees@kernel.org,jorgelo@chromium.org,johannes@sipsolutions.net,jason@zx2c4.com,jannh@google.com,hch@lst.de,hca@linux.ibm.com,groeck@chromium.org,gerg@kernel.org,f.fainelli@gmail.com,enh@google.com,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,benjamin@sipsolutions.net,avagin@gmail.com,ardb@kernel.org,anna-maria@linutronix.de,aleksandr.mikhalitsyn@canonical.com,adobriyan@gmail.com,adhemerval.zanella@linaro.org,42.hyeyoo@gmail.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mseal-sysmap-update-msealrst.patch removed from -mm tree
Message-Id: <20250401221836.5DC34C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal sysmap: update mseal.rst
has been removed from the -mm tree.  Its filename was
     mseal-sysmap-update-msealrst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: mseal sysmap: update mseal.rst
Date: Wed, 5 Mar 2025 02:17:10 +0000

Update memory sealing documentation to include details about system
mappings.

Link: https://lkml.kernel.org/r/20250305021711.3867874-7-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Berg <benjamin@sipsolutions.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Elliot Hughes <enh@google.com>
Cc: Florian Faineli <f.fainelli@gmail.com>
Cc: Greg Ungerer <gerg@kernel.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Röttger <sroettger@google.com>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mseal.rst |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/Documentation/userspace-api/mseal.rst~mseal-sysmap-update-msealrst
+++ a/Documentation/userspace-api/mseal.rst
@@ -130,6 +130,26 @@ Use cases
 
 - Chrome browser: protect some security sensitive data structures.
 
+- System mappings:
+  The system mappings are created by the kernel and includes vdso, vvar,
+  vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
+
+  Those system mappings are readonly only or execute only, memory sealing can
+  protect them from ever changing to writable or unmmap/remapped as different
+  attributes. This is useful to mitigate memory corruption issues where a
+  corrupted pointer is passed to a memory management system.
+
+  If supported by an architecture (CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS),
+  the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
+  architecture.
+
+  The following architectures currently support this feature: x86-64 and arm64.
+
+  WARNING: This feature breaks programs which rely on relocating
+  or unmapping system mappings. Known broken software at the time
+  of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
+  this config can't be enabled universally.
+
 When not to use mseal
 =====================
 Applications can apply sealing to any virtual memory region from userspace,
_

Patches currently in -mm which might be from jeffxu@chromium.org are


