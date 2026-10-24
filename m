Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832332;
	b=2ycJw1/krzReZwFDGKIzai4CtWRn9VTb3kkLMEzPg0Eqmf/VXHWkgtIOAV/inGW13EZz
	 hw3AFyFiBBRzF7hBXaE9vgaRWQaU2YypG4AniyyqCb2c7jPry8Uai654acpMJ7/jSet5C
	 KNxZ84sAOQauPqR5r9h9MI5OuIf/iqjOa5uWSwowOgN95SBLrlFs+en1kMfbLfl3VE01P
	 1D8Oz7G+aUSGbQJoOzEbkUayqR9vPJ58t8uzSLEPBG+408m7mSW9QxvPXQxlWWdJ4wp1/
	 g2+/UzGhgjRxVWCQSUt/xyPG06eK+9uWq8w5fF6Ucp7eNZtRwVvPQ/rUbrqIpyo+mLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832332;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=vvLdcqtbUAK43AqX6xSQgfE5VzEKULR223qUVGestik=;
	b=pynqQ2ucTQEyz04xIxXFcusD1mh5c3ai/Gc7Hj1bOvCfpb68WuTI+cRgmUEzkRyN/4yj
	 DlyRitFjNrZQbxr0c8Vfhx70ysOqq+0e7z/46ly9ewAJlXgZiYxX3JxFzexJ1JqGA4kbf
	 +1cIPr708/Tem/FHpl2FPtaHhUamdvFYmo3cljdKfT9td4Y0fD5g/GgGqjNWxX7PStovl
	 goerf5EBvvxMxpHk3zRHvehc4TNI7KS8W0jmZvM8+9EeFdL0QkwSMESqpUhIxfb6vMsdB
	 ySdrJtyfd3i7MQFh1qvt6YdY4XbtwHOLhA6hUpiSLqk6jIMTQh1bxHzzMlElZ02e0fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=orwDMNMf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7F2606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=orwDMNMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010D21F01828;
	Sat, 24 Oct 2026 08:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832332;
	bh=vvLdcqtbUAK43AqX6xSQgfE5VzEKULR223qUVGestik=;
	h=Date:To:From:Subject;
	b=orwDMNMf6JNatgE9tJRKal7ig5Ulo9oGuvWD3uyOe9ZLnaGtDor14ntVwWLa6JWkw
	 DrlJoiv0/6D/1nyaHJMKwdyTpSTFFcA5s6449NfqrDr8SOjb7QpY2KWVCOoXk8YLGD
	 tWPxbLMXVCGqS7yCfCnFz22a/PLxGv0hJjpmYa1E=
Date: Sat, 24 Oct 2026 01:58:51 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-init-remove-call-the-memblock_set_node.patch removed from -mm tree
Message-Id: <20261024085852.010D21F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: sh: init: remove call the memblock_set_node()
has been removed from the -mm tree.  Its filename was
     sh-init-remove-call-the-memblock_set_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: init: remove call the memblock_set_node()
Date: Sun, 10 May 2026 16:55:44 +0300

Without CONFIG_NUMA, the call to memblock_set_node() is not needed.

Remove it.

Link: https://lore.kernel.org/20260510135546.13554-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/sh/kernel/setup.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/sh/kernel/setup.c~sh-init-remove-call-the-memblock_set_node
+++ a/arch/sh/kernel/setup.c
@@ -228,9 +228,6 @@ void __init __add_active_range(unsigned
 	 */
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
-
-	memblock_set_node(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
-			  &memblock.memory, nid);
 }
 
 void __init __weak plat_early_device_setup(void)
_

Patches currently in -mm which might be from rppt@kernel.org are


