Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CA278C8A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103882; cv=none; b=TaIPzPngEeQurapPoUpPl8ogudafs+r5F7k3WRJfBRo4bxL+aTazAbcHBOpZai4bYTJQdgj2F7pwh7k3MwvSxj2fkYK9NV08s6zerMvy9ClbVw8jnI6ST8dYkFisqDnKIt9JFxsJQod+r6YSX0590vSbGmQtfYL04UPHkZNxgSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103882; c=relaxed/simple;
	bh=ZzGXvTuL2QAZo7eg8xeijXYDiskAiI5nEMg2AKkLSw0=;
	h=Date:To:From:Subject:Message-Id; b=Y1NW/kgB3gIhvOrIUYhGHLSVHAECgVGcIM1S5djuNOoahemYknzBm+/aLzCG7QjFHUrtI442HMA3iwos9b86GBGlXt5BMmb6/uVN+pyhgrRNnGT81SWxVBiCcJEh1XTjItKlDsN7jrUsAUc11Gasa377zCzjdN+LFS4UitYDo3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CY5oEkwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CY5oEkwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C59C116B1;
	Fri, 26 Apr 2024 03:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103881;
	bh=ZzGXvTuL2QAZo7eg8xeijXYDiskAiI5nEMg2AKkLSw0=;
	h=Date:To:From:Subject:From;
	b=CY5oEkwKVzUno0vnLSCUXx7z2mR8NL6hYVDjG7WDGtctzGbzk3P3r1N+3g4ULF5he
	 Voj6/K7c5ZCTs4nD2wj295nCAGVMH04R4nsd9U84PQ6Mmj8DPtc23Yq7Lhe3LmaIRz
	 eBuR1+9qG0i9ruTBtQ8e5w6Lki3p4JhodQyeIzWM=
Date: Thu, 25 Apr 2024 20:58:01 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scripts-kallysms-always-include-__start-and-__stop-symbols.patch removed from -mm tree
Message-Id: <20240426035801.D2C59C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/kallysms: always include __start and __stop symbols
has been removed from the -mm tree.  Its filename was
     scripts-kallysms-always-include-__start-and-__stop-symbols.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: scripts/kallysms: always include __start and __stop symbols
Date: Thu, 21 Mar 2024 09:36:26 -0700

These symbols are used to denote section boundaries: by always including
them we can unify loading sections from modules with loading built-in
sections, which leads to some significant cleanup.

Link: https://lkml.kernel.org/r/20240321163705.3067592-5-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/scripts/kallsyms.c~scripts-kallysms-always-include-__start-and-__stop-symbols
+++ a/scripts/kallsyms.c
@@ -204,6 +204,11 @@ static int symbol_in_range(const struct
 	return 0;
 }
 
+static bool string_starts_with(const char *s, const char *prefix)
+{
+	return strncmp(s, prefix, strlen(prefix)) == 0;
+}
+
 static int symbol_valid(const struct sym_entry *s)
 {
 	const char *name = sym_name(s);
@@ -211,6 +216,14 @@ static int symbol_valid(const struct sym
 	/* if --all-symbols is not specified, then symbols outside the text
 	 * and inittext sections are discarded */
 	if (!all_symbols) {
+		/*
+		 * Symbols starting with __start and __stop are used to denote
+		 * section boundaries, and should always be included:
+		 */
+		if (string_starts_with(name, "__start_") ||
+		    string_starts_with(name, "__stop_"))
+			return 1;
+
 		if (symbol_in_range(s, text_ranges,
 				    ARRAY_SIZE(text_ranges)) == 0)
 			return 0;
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


