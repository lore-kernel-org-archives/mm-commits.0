Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755903;
	b=j7ukBBBPj3E1u9tKKoRdLND3qy4YeXzCtSxs3s0mhhe5JEEpdLdZE8DvYYBa08/OgaPx
	 yx5KL4oXvRWLhJngXYLcikJSxiFiaxBohM16aKuTn5WJ+02CcNh64eLWk/A8YFFPIktqZ
	 SYG+v87MHJOJEKnteXTagLOKIR/RhQ5yPHeKC3I1+7nGnph0LygaKc1zQmkEsQI6OIBxi
	 p0dKtDcxhtasBmJ4e8MNtk5iCmsmRnTnynIm03jvFSmeOtNqOQ5feUmktiC/x/BtmArGX
	 rKuXV1XKzOT4KRJ2jFH0b9FmD+N9gbu4v6o1e3rmL01+mh2O6BbZISK0924Ei8ki3mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755903;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bpSxfY+ZN2YTBYPNgbN16onUiqK6C2+LdIZ8YCcux/0=;
	b=xB20qA+lyqih++nOl1KtlZTaGECeWRuZ9MnAriVh3vdArskdg2bqf6N5GqE54ZhFXGPl
	 uBwn/Oihwr4TdySdm7tfQSxnFypc+seByP5KgEGp011CFVsuSJw7lhXAh8EoZIA2sz7B+
	 kOXmQg8Rdovxj5wEs2fiy0M/negrFsUWBe4JOlExytDt2y9T/noC5nhrXbVOlJq6vrg6E
	 +xSoebPmjxzeAoFMUMDeBXNWOEnpBvOZ4RueFmGY1HFMCYp459g0qBxtHNeLAxs+DKdX7
	 TUlcKSOfYfWVL7VPzHm91G/1D6ZWn6MvYxaA4dQJFV0NHUxLaHZZitzoV9ldcZsr3Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZLiFbQDx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102A4606A323
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZLiFbQDx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C57E1F000C4;
	Sun, 15 Nov 2026 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794755902;
	bh=bpSxfY+ZN2YTBYPNgbN16onUiqK6C2+LdIZ8YCcux/0=;
	h=Date:To:From:Subject;
	b=ZLiFbQDxJdSsH+9ZeRrythAK4ztd9kUv7CEOW1COIVOabT6B7/wx5rT2ULKHtEkVe
	 AKmKdY2rUU/T+UAaB55RGbWUJoube1S41z0i2JOmLiGsldJtK/HMvg2Z8vlvI6IEpx
	 c424B9+PKdvL4zNYtaJRCkOjAFKA25lM50pl38Qc=
Date: Sun, 15 Nov 2026 07:18:22 -0800
To: mm-commits@vger.kernel.org,wfelipe@google.com,ryan.roberts@arm.com,
	rppt@kernel.org,mhiramat@kernel.org,leitao@debian.org,ekffu200098@gmail.com,
	brauner@kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-use-strscpy-in-initcall_blacklist.patch added to mm-nonmm-unstable branch
Message-Id: <20261115151822.8C57E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: init: use strscpy() in initcall_blacklist()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-use-strscpy-in-initcall_blacklist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-use-strscpy-in-initcall_blacklist.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Thorsten Blum <blum@kernel.org>
Subject: init: use strscpy() in initcall_blacklist()
Date: Sun, 15 Nov 2026 15:23:20 +0100

Replace the deprecated strcpy() [1] with strscpy() to bound the copy to
the allocated buffer size.

Also use a simple while loop to reduce code indentation.

Link: https://lore.kernel.org/20261115142321.96774-3-blum@kernel.org
Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Mike Rapoport <rppt@kernel.org>

 init/main.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/init/main.c~init-use-strscpy-in-initcall_blacklist
+++ a/init/main.c
@@ -1286,18 +1286,15 @@ static int __init initcall_blacklist(cha
 	struct blacklist_entry *entry;
 
 	/* str argument is a comma-separated list of functions */
-	do {
-		str_entry = strsep(&str, ",");
-		if (str_entry) {
-			pr_debug("blacklisting initcall %s\n", str_entry);
-			entry = memblock_alloc_or_panic(sizeof(*entry),
-					       SMP_CACHE_BYTES);
-			entry->buf = memblock_alloc_or_panic(strlen(str_entry) + 1,
-						    SMP_CACHE_BYTES);
-			strcpy(entry->buf, str_entry);
-			list_add(&entry->next, &blacklisted_initcalls);
-		}
-	} while (str_entry);
+	while ((str_entry = strsep(&str, ","))) {
+		size_t buf_size = strlen(str_entry) + 1;
+
+		pr_debug("blacklisting initcall %s\n", str_entry);
+		entry = memblock_alloc_or_panic(sizeof(*entry), SMP_CACHE_BYTES);
+		entry->buf = memblock_alloc_or_panic(buf_size, SMP_CACHE_BYTES);
+		strscpy(entry->buf, str_entry, buf_size);
+		list_add(&entry->next, &blacklisted_initcalls);
+	}
 
 	return 1;
 }
_

Patches currently in -mm which might be from blum@kernel.org are

init-reject-bare-rodata-parameter-before-architecture-parsing.patch
init-use-strscpy-in-do_initcalls.patch
init-use-kmalloc-in-do_initcalls.patch
init-remove-strlcat-and-sprintf-from-do_one_initcall.patch
init-use-strscpy-in-initcall_blacklist.patch
init-combine-blacklist-entry-allocations-in-initcall_blacklist.patch

