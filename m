Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3B7DDAB
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417639; cv=none; b=UKyeQkiiXxqiU9MLIpsIZFj6NSWlEKHLaqlH6MUsXjxYCLt2JdWLkirZc+GPb+F2gz2V6dI8sQ5OCzov/Fft8K6zp2ReOiSA+zMNNxZDBAcWlkf1rkzW+dGVpwG/RNL49yjOSQa8HGpFj2ftD6Y0nzb4Uxt0gk6WsgRa6ltMH6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417639; c=relaxed/simple;
	bh=hXj8Zi/8ZdapnC94OsynwiIXiG8EgEf+8PgnMVgBhsE=;
	h=Date:To:From:Subject:Message-Id; b=oJlTEj9XPotuo9qi7mCuyd75E/KGP5BQIWaArdFnGGRnXBuGCsqkuWY036D58Gl+PoD5ly+qp0pNMnm/yLl2d/4Q7howQSAiVLxvhmRghUDC8lDe06en1STbsKNWCzMyuAThNgZRpWEv86yvhaLgQ9G34i5zMtTK3YI7+8gQlpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jjbbtZZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jjbbtZZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AD5C4CEE2;
	Sat, 12 Apr 2025 00:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417639;
	bh=hXj8Zi/8ZdapnC94OsynwiIXiG8EgEf+8PgnMVgBhsE=;
	h=Date:To:From:Subject:From;
	b=jjbbtZZHmUYMWUlh/Ab7YYrKIyfRTrm9zdGZ6KisSVE98kBJwEFYLEeRlvwZ9uwrW
	 2nxfdpxWggJLG0gzdfrIJ+yITGXl41zmLZaosAMLwwceFVCOC93/BwJf99X3a2i8g1
	 SIGBomlG6mgC5cDK702S5szmmB6JdHmxP4d9elUs=
Date: Fri, 11 Apr 2025 17:27:18 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,pmladek@suse.com,mbenes@suse.cz,masahiroy@kernel.org,jpoimboe@kernel.org,joe.lawrence@redhat.com,jikos@kernel.org,jeff.johnson@oss.qualcomm.com,eahariha@linux.microsoft.com,christophe.leroy@csgroup.eu,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] samples-livepatch-add-module-descriptions-fix.patch removed from -mm tree
Message-Id: <20250412002719.12AD5C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples-livepatch-add-module-descriptions-fix
has been removed from the -mm tree.  Its filename was
     samples-livepatch-add-module-descriptions-fix.patch

This patch was dropped because it was folded into samples-livepatch-add-module-descriptions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: samples-livepatch-add-module-descriptions-fix
Date: Sun Apr  6 06:44:58 PM PDT 2025

match the livepatch-callbacks-mod.c description, per Petr

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/livepatch/livepatch-callbacks-busymod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/livepatch/livepatch-callbacks-busymod.c~samples-livepatch-add-module-descriptions-fix
+++ a/samples/livepatch/livepatch-callbacks-busymod.c
@@ -56,5 +56,5 @@ static void livepatch_callbacks_mod_exit
 
 module_init(livepatch_callbacks_mod_init);
 module_exit(livepatch_callbacks_mod_exit);
-MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks");
+MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks, support module");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

samples-livepatch-add-module-descriptions.patch
mm-kasan-add-module-decription-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix.patch

