Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4AC2FF16F
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308806; cv=none; b=hYM9rDjdQq0EhW1aKocPSqdsMgXciE1XaiYf9HL7bli6q37TxqzDdcJa0IVH+wnh3HD3otF3kRn1VidJ7dWRXggAnSZWayIlnikkt+7UNMxezIzLFwsfpFT3T1PBgmpeAPRR4KZVVI5BGlMAQudVJNSPah37PqKRKXMsGdCAoaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308806; c=relaxed/simple;
	bh=J2ik7Jg07jlAG4lVkX9ZN9Bw4zv0JMSapupBAgEmEYc=;
	h=Date:To:From:Subject:Message-Id; b=gYFVDLqjQanBIcaQON0d0qKgwih+ke//LTBt8qwbZ9cBzeJL8KRGSvgT5eqJmwWBloB80Z4j8gjMdsJhZOhjTV6CjvdcTpMzHlj7k0qq9bH1DXiPJhBqiVy8b7abpZ3EJG6IC/tpd3TzfYyhxLKYr/p/VvSdavWDBKH3PcWjdwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKginutL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKginutL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDFEC4CEF5;
	Tue,  9 Dec 2025 19:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308806;
	bh=J2ik7Jg07jlAG4lVkX9ZN9Bw4zv0JMSapupBAgEmEYc=;
	h=Date:To:From:Subject:From;
	b=vKginutLiotSKnp0aI0B7EjfQQe5kGcDoM9NXAv51Nzq/5B/klaJc5WBlm9QPZONl
	 jH5hzUnwvLSEOHIeZQbGy2uMOh2JYVbialdUm/kBYXiFPQ9HCNO+Y0t0zgDr87Qusx
	 jtqi1IwltsXhFikRGk2+/2edhHc1O8nvkxjX/IX8=
Date: Tue, 09 Dec 2025 11:33:25 -0800
To: mm-commits@vger.kernel.org,vireshk@kernel.org,sboyd@kernel.org,nm@ti.com,lukas.bulwahn@gmail.com,krzk@kernel.org,joe@perches.com,james.bottomley@HansenPartnership.com,geert@linux-m68k.org,dwaipayanray1@gmail.com,david.hunter.linux@gmail.com,dan.j.williams@intel.com,dan.carpenter@linaro.org,corbet@lwn.net,apw@canonical.com,allyheev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-uninitialized-pointer-with-__free-attribute-check.patch removed from -mm tree
Message-Id: <20251209193326.2DDFEC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: add uninitialized pointer with __free attribute check
has been removed from the -mm tree.  Its filename was
     checkpatch-add-uninitialized-pointer-with-__free-attribute-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ally Heev <allyheev@gmail.com>
Subject: checkpatch: add uninitialized pointer with __free attribute check
Date: Wed, 03 Dec 2025 20:58:49 +0530

Uinitialized pointers with __free attribute can cause undefined behavior
as the memory randomly assigned to the pointer is freed automatically when
the pointer goes out of scope.  add check in checkpatch to detect such
issues.

Link: https://lkml.kernel.org/r/20251203-aheev-checkpatch-uninitialized-free-v7-1-841e3b31d8f3@gmail.com
Signed-off-by: Ally Heev <allyheev@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/all/8a4c0b43-cf63-400d-b33d-d9c447b7e0b9@suswa.mountain/
Link: https://lore.kernel.org/all/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.camel@HansenPartnership.com/
Acked-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Menon, Nishanth <nm@ti.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Viresh Kumar <vireshk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/checkpatch.rst |   23 +++++++++++++++++++++++
 scripts/checkpatch.pl                  |    6 ++++++
 2 files changed, 29 insertions(+)

--- a/Documentation/dev-tools/checkpatch.rst~checkpatch-add-uninitialized-pointer-with-__free-attribute-check
+++ a/Documentation/dev-tools/checkpatch.rst
@@ -1009,6 +1009,29 @@ Functions and Variables
 
       return bar;
 
+  **UNINITIALIZED_PTR_WITH_FREE**
+    Pointers with __free attribute should be declared at the place of use
+    and initialized (see include/linux/cleanup.h). In this case
+    declarations at the top of the function rule can be relaxed. Not doing
+    so may lead to undefined behavior as the memory assigned (garbage,
+    in case not initialized) to the pointer is freed automatically when
+    the pointer goes out of scope.
+
+    Also see: https://lore.kernel.org/lkml/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.camel@HansenPartnership.com/
+
+    Example::
+
+      type var __free(free_func);
+      ... // var not used, but, in future someone might add a return here
+      var = malloc(var_size);
+      ...
+
+    should be initialized as::
+
+      ...
+      type var __free(free_func) = malloc(var_size);
+      ...
+
 
 Permissions
 -----------
--- a/scripts/checkpatch.pl~checkpatch-add-uninitialized-pointer-with-__free-attribute-check
+++ a/scripts/checkpatch.pl
@@ -7732,6 +7732,12 @@ sub process {
 				ERROR("MISSING_SENTINEL", "missing sentinel in ID array\n" . "$here\n$stat\n");
 			}
 		}
+
+# check for uninitialized pointers with __free attribute
+		while ($line =~ /\*\s*($Ident)\s+__free\s*\(\s*$Ident\s*\)\s*[,;]/g) {
+			ERROR("UNINITIALIZED_PTR_WITH_FREE",
+			      "pointer '$1' with __free attribute should be initialized\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from allyheev@gmail.com are


