Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF14B1CEAC2
	for <mm-commits@vger.kernel.org>; Sun,  9 Nov 2025 19:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762715311; cv=none; b=sQNPl29ohnh5qLKo3jQkFTdcnFV9vxF7ep+a6D2tXeayxEV8/sIIfAUa/OCcz7FLD6BlSWd9Tcykz2lW553UEq3S8AiF+TNxHK8DT32ZTRh98gRc4j7D/1oH4Xc3hyqLY/fXgnLKW4Qacm6PdWWEnz/8c03yDEc4sGn39kHYyuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762715311; c=relaxed/simple;
	bh=baji+rakwB6LKuA5RLvNuqcVQAYCM+NP/krQHafBwVY=;
	h=Date:To:From:Subject:Message-Id; b=iTRlpdLZrmakvRSXvm2ADwZFJV4kAjekDjNiq1z9jjlsd/93mg8L+QW+r7EDZen3HBoeC9ihKp5pgUzcfzLSVr1AMo0ypAybyamASfqstPwmCt8w5eyRguSZvhEyUe1/cyEQk5nsT/ObsTM+Fu4N0/8FkbbGoPXV7NBFzemDQrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fro/fVUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fro/fVUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCF3C19421;
	Sun,  9 Nov 2025 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762715310;
	bh=baji+rakwB6LKuA5RLvNuqcVQAYCM+NP/krQHafBwVY=;
	h=Date:To:From:Subject:From;
	b=fro/fVUsqZ6wAADC2IZAJvKafEComR/afAi9pJQUZA6nVK7pBfXE1RIZt5tPrr8zW
	 JrIgqxvZY1wvthHz24Nb1GP+vua0x/GljM2SXVCB8HU35q6eK7HsoCyOMqnY+hOY7n
	 8jOuqWrys/7VT9+I2v7GgbUtLtizZ+RokbL8RqC4=
Date: Sun, 09 Nov 2025 11:08:29 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,skhawaja@google.com,rdunlap@infradead.org,pratyush@kernel.org,pasha.tatashin@soleen.com,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,graf@amazon.com,dmatlack@google.com,corbet@lwn.net,brauner@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix.patch removed from -mm tree
Message-Id: <20251109190830.4FCF3C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
has been removed from the -mm tree.  Its filename was
     liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix.patch

This patch was dropped because it was folded into liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
Date: Wed, 29 Oct 2025 10:48:11 +0200

fix KEXEC_HANDOVER_DEBUG Kconfig dependency

Link: https://lkml.kernel.org/r/aQHUyyFtiNZhx8jo@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/Kconfig.kexec~liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
+++ a/kernel/Kconfig.kexec
@@ -111,7 +111,7 @@ config KEXEC_HANDOVER
 
 config KEXEC_HANDOVER_DEBUG
 	bool "Enable Kexec Handover debug checks"
-	depends on KEXEC_HANDOVER_DEBUGFS
+	depends on KEXEC_HANDOVER
 	help
 	  This option enables extra sanity checks for the Kexec Handover
 	  subsystem. Since, KHO performance is crucial in live update
_

Patches currently in -mm which might be from rppt@kernel.org are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
kho-drop-notifiers.patch

