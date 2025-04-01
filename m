Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E243421D5A2
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545909; cv=none; b=fpb8QL30DLX6ajx1oFLnFuZe+HY3Oo45s7wZ2lG4m7MLxK/P9aBW/QFW+F85/dqeUlUGY3mZW7A5/IqvqkXE15MPIGUHU768hxJqz9K4K82uYooM6HTBUY4CnCEX4Wd5QcQndfeBTLrzXd9NyWMYTrOz40ggvhxcBlYY5797Jw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545909; c=relaxed/simple;
	bh=G0JZVpfDzLOwMiTXvsblIlK3ibLvUFjDXHTKNTUxHk8=;
	h=Date:To:From:Subject:Message-Id; b=O9HCWY3OfnfvZDHQAawGK2cs1+//RYGuY3BsNEdsB9zoceFMhN5m4A8KANcING/aYJfdIWWQeoc6PXjhXFAvovoPCwOm/JTth8x3W+egzLkKpFZKJfERaDrNHr9ac2Y1RlKrc1AHtZ7sueXQux7fHOjvWhWDn17pqEPfF7C8BLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zJ14XUnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zJ14XUnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01983C4CEE4;
	Tue,  1 Apr 2025 22:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545908;
	bh=G0JZVpfDzLOwMiTXvsblIlK3ibLvUFjDXHTKNTUxHk8=;
	h=Date:To:From:Subject:From;
	b=zJ14XUnHHWchLs8u4N+cofyerk2ZdC48eqLGjILzemWRQ5WQHTHRDRX+1mwVV6od4
	 xCfFLYRUB+pXFN8QC4gK5OWr1iqnDAfwoqbWhg/gS/2AVu3aihIXFPbJWd9TYSkter
	 Tm4fFxJjG8V4r0KTwbQ0o16NsmA5xCBnmLhWeu7w=
Date: Tue, 01 Apr 2025 15:18:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.weissschuh@linutronix.de,sroettger@google.com,rientjes@google.com,rdunlap@infradead.org,peterx@redhat.com,pedro.falcato@gmail.com,oleg@redhat.com,ojeda@kernel.org,mpe@ellerman.id.au,mingo@kernel.org,mike.rapoport@gmail.com,mhocko@suse.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,Liam.Howlett@oracle.com,kees@kernel.org,jorgelo@chromium.org,johannes@sipsolutions.net,jason@zx2c4.com,jannh@google.com,hch@lst.de,hca@linux.ibm.com,groeck@chromium.org,gerg@kernel.org,f.fainelli@gmail.com,enh@google.com,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,benjamin@sipsolutions.net,avagin@gmail.com,ardb@kernel.org,anna-maria@linutronix.de,aleksandr.mikhalitsyn@canonical.com,adobriyan@gmail.com,adhemerval.zanella@linaro.org,42.hyeyoo@gmail.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-x86-test_mremap_vdso-skip-if-vdso-is-msealed.patch removed from -mm tree
Message-Id: <20250401221828.01983C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: x86: test_mremap_vdso: skip if vdso is msealed
has been removed from the -mm tree.  Its filename was
     selftests-x86-test_mremap_vdso-skip-if-vdso-is-msealed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: selftests: x86: test_mremap_vdso: skip if vdso is msealed
Date: Wed, 5 Mar 2025 02:17:06 +0000

Add code to detect if the vdso is memory sealed, skip the test if it is.

Link: https://lkml.kernel.org/r/20250305021711.3867874-3-jeffxu@google.com
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

 tools/testing/selftests/x86/test_mremap_vdso.c |   43 +++++++++++++++
 1 file changed, 43 insertions(+)

--- a/tools/testing/selftests/x86/test_mremap_vdso.c~selftests-x86-test_mremap_vdso-skip-if-vdso-is-msealed
+++ a/tools/testing/selftests/x86/test_mremap_vdso.c
@@ -14,6 +14,7 @@
 #include <errno.h>
 #include <unistd.h>
 #include <string.h>
+#include <stdbool.h>
 
 #include <sys/mman.h>
 #include <sys/auxv.h>
@@ -55,13 +56,55 @@ static int try_to_remap(void *vdso_addr,
 
 }
 
+#define VDSO_NAME "[vdso]"
+#define VMFLAGS "VmFlags:"
+#define MSEAL_FLAGS "sl"
+#define MAX_LINE_LEN 512
+
+bool vdso_sealed(FILE *maps)
+{
+	char line[MAX_LINE_LEN];
+	bool has_vdso = false;
+
+	while (fgets(line, sizeof(line), maps)) {
+		if (strstr(line, VDSO_NAME))
+			has_vdso = true;
+
+		if (has_vdso && !strncmp(line, VMFLAGS, strlen(VMFLAGS))) {
+			if (strstr(line, MSEAL_FLAGS))
+				return true;
+
+			return false;
+		}
+	}
+
+	return false;
+}
+
 int main(int argc, char **argv, char **envp)
 {
 	pid_t child;
+	FILE *maps;
 
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	maps = fopen("/proc/self/smaps", "r");
+	if (!maps) {
+		ksft_test_result_skip(
+			"Could not open /proc/self/smaps, errno=%d\n",
+			 errno);
+
+		return 0;
+	}
+
+	if (vdso_sealed(maps)) {
+		ksft_test_result_skip("vdso is sealed\n");
+		return 0;
+	}
+
+	fclose(maps);
+
 	child = fork();
 	if (child == -1)
 		ksft_exit_fail_msg("failed to fork (%d): %m\n", errno);
_

Patches currently in -mm which might be from jeffxu@chromium.org are


