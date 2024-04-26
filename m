Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A963823B5
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104474; cv=none; b=qjoWbFoePRyrPzVMNPeL/8AOYCcjP9C418OmUfOEBTAgOzMYWsUHUqCT6JjbNzbSOhBSWgqV3kqWJXgtP7PfPAMNt3106TJH5FcRIq2ABbuofQgCaxVv/kWfxZu6fFGoS3e5dpwtGA56/IaeyoYUSPv7RwzNRhscYkm5S0mlaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104474; c=relaxed/simple;
	bh=I+gI865RgUPw/yMZ/2I5Cy4EoxwiDtnThNuyrQONM6U=;
	h=Date:To:From:Subject:Message-Id; b=SCqmxQN6QEuF9FJ2aGQrUUeu7PHtTMNFwChnnCa9xVUFh/n6OUruPm2BIyTEnVpR5SZlmvgIgBfDjOD2pdkkLD9rk+DJUS4OuBeW/K0t7DiLSG4jcE7H19QIFZq8AACIJfZIFhRRXG8w94uAy4XJJJcl8P3NisWaFVI0VEfy48k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8PDR4H+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8PDR4H+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D319BC116B1;
	Fri, 26 Apr 2024 04:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104473;
	bh=I+gI865RgUPw/yMZ/2I5Cy4EoxwiDtnThNuyrQONM6U=;
	h=Date:To:From:Subject:From;
	b=A8PDR4H+IFCJ1r/4JWYuO7ltk06yTClmKv50YiA6qVvzsXJ6YdRXjW/8jLOoA1FZb
	 wVw6cEPlkiO/umWjyefUXleDU06ctg+1THUo4iQsa8aBlM2zkuiOY7y2EL9tDnxBzF
	 HxgnxUGap31EWQpK6zlkfLd2caZuoJdwyMnv0iYs=
Date: Thu, 25 Apr 2024 21:07:53 -0700
To: mm-commits@vger.kernel.org,arnd@kernel.org,schnelle@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kgdb-add-has_ioport-dependency.patch removed from -mm tree
Message-Id: <20240426040753.D319BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kgdb: add HAS_IOPORT dependency
has been removed from the -mm tree.  Its filename was
     kgdb-add-has_ioport-dependency.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: kgdb: add HAS_IOPORT dependency
Date: Wed, 3 Apr 2024 15:25:47 +0200

In a future patch HAS_IOPORT=n will disable inb()/outb() and friends at
compile time.  We thus need to add HAS_IOPORT as dependency for those
drivers using them.

Link: https://lkml.kernel.org/r/20240403132547.762429-2-schnelle@linux.ibm.com
Co-developed-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kgdb |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.kgdb~kgdb-add-has_ioport-dependency
+++ a/lib/Kconfig.kgdb
@@ -122,6 +122,7 @@ config KDB_DEFAULT_ENABLE
 config KDB_KEYBOARD
 	bool "KGDB_KDB: keyboard as input device"
 	depends on VT && KGDB_KDB && !PARISC
+	depends on HAS_IOPORT
 	default n
 	help
 	  KDB can use a PS/2 type keyboard for an input device
_

Patches currently in -mm which might be from schnelle@linux.ibm.com are


