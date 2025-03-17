Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9B0140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189510; cv=none; b=GZO7XKRp8J4m2tVQzcx6jPfegvZ5wXdb/9ivGadCn4AWkM39ZYEchEtaEBNW+qosXLbIL6o5LIVRRIMv7/MzLtRA8T/3hnVfphb0xL3iPr4MvmJMxHDAWLxCg/HvsDq9O7etRQl2leRaVcwNi5TPEZN5jxOkfFC9Eaacomb0+ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189510; c=relaxed/simple;
	bh=wniqXODHDZ++47z2klau6y8nSJU9YePe7jNIfef/bzg=;
	h=Date:To:From:Subject:Message-Id; b=Gtryy1Qh86Mqb1ozODKcwqhkwgdWvrhtaGvmlhYO6gfINwgRkyVhYA2qatOkyTIv9U08H70h/ktB9EAP4/EibOGMQVdqAj98mBuuqOv+w4ajQJvdl8QFxFiG9TB1PluTr6dIj3wDkKDmSVHa6XkoAAsw58Q1RqdmhLfO0l6YWLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G+pVykaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G+pVykaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5115AC4CEEC;
	Mon, 17 Mar 2025 05:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189510;
	bh=wniqXODHDZ++47z2klau6y8nSJU9YePe7jNIfef/bzg=;
	h=Date:To:From:Subject:From;
	b=G+pVykaHk1YkRFLUV42hY3xJSag9yhBRxsmdBdrrm2qeU5DhT/KMMngL3jMTWzLR1
	 ydEGEXGmG/lKR8UtCwgrjdwrHY1A2e7H+haw3ZKx2FxfSG7Xy6L5FsdjQOJOcSaZnR
	 tNXQUFzBSNc/xlAfucnTRbEHV1YnTiB83Cvg2QAo=
Date: Sun, 16 Mar 2025 22:31:49 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,gary@garyguo.net,dwaipayanray1@gmail.com,charmitro@posteo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,apw@canonical.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,kurti@invicto.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch removed from -mm tree
Message-Id: <20250317053150.5115AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: add warning for pr_* and dev_* macros without a trailing newline
has been removed from the -mm tree.  Its filename was
     checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alban Kurti <kurti@invicto.ai>
Subject: checkpatch: add warning for pr_* and dev_* macros without a trailing newline
Date: Fri, 07 Feb 2025 18:39:06 +0000 (UTC)

Add a new check in scripts/checkpatch.pl to detect usage of pr_(level) and
dev_(level) macros (for both C and Rust) when the string literal does not
end with '\n'.  Missing trailing newlines can lead to incomplete log lines
that do not appear properly in dmesg or in console output.  To show an
example of this working after applying the patch we can run the script on
the commit that likely motivated this need/issue:

  ./scripts/checkpatch.pl --strict -g "f431c5c581fa1"

Also, the patch is able to handle correctly if there is a printing call
without a newline which then has a newline printed via pr_cont for both
Rust and C alike.  If there is no newline printed and the patch ends or
there is another pr_* call before a newline with pr_cont is printed it
will show a warning.  Not implemented for dev_cont because it is not clear
to me if that is used at all.

One false warning that will be generated due to this change is in case we
have a patch that modifies a `pr_* call without a newline` which has a
pr_cont with a newline following it.  In this case there will be a warning
but because the patch does not include the following pr_cont it will warn
there is nothing creating a newline.  I have modified the warning to be
softer due to this known problem.

I have tested with comments, whitespace, differen orders of pr_* calls and
pr_cont and the only case that I suspect to be a problem is the one
outlined above.

Link: https://lkml.kernel.org/r/20250207-checkpatch-newline2-v4-1-26d8e80d0059@invicto.ai
Signed-off-by: Alban Kurti <kurti@invicto.ai>
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://github.com/Rust-for-Linux/linux/issues/1140
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Charalampos Mitrodimas <charmitro@posteo.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   96 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline
+++ a/scripts/checkpatch.pl
@@ -77,6 +77,8 @@ my ${CONFIG_} = "CONFIG_";
 
 my %maybe_linker_symbol; # for externs in c exceptions, when seen in *vmlinux.lds.h
 
+my $pending_log = undef;
+
 sub help {
 	my ($exitcode) = @_;
 
@@ -3878,6 +3880,91 @@ sub process {
 			}
 		}
 
+# check for pr_* and dev_* logs without a newline for C and Rust files to avoid missing log messages
+  my $pr_cont_pattern = qr{
+      \b
+      pr_cont!?
+      \s*
+      \(
+      \s*
+      "([^"]*)"
+      [^)]*
+      \)
+  }x;
+  my $log_macro_pattern = qr{
+      \b
+      (
+          pr_(?:emerg|alert|crit|err|warn|notice|info|debug)
+        | dev_(?:emerg|alert|crit|err|warn|notice|info|dbg)
+      )
+      (!?)
+      \s*
+      \(
+      \s*
+      "([^"]*)"
+  }x;
+
+  if ($realfile =~ /\.(?:c|h|rs)$/) {
+      if ($rawline =~ /^\+/) {
+          my $cleanline = $rawline;
+          $cleanline =~ s/^[+\s]+//;
+          $cleanline =~ s/\r?$//;
+          $cleanline =~ s{/\*.*?\*/}{}g;
+          $cleanline =~ s{//.*}{}g;
+
+          if ($pending_log) {
+              if ($cleanline =~ /$pr_cont_pattern/) {
+                  my $cont_string_arg = $1;
+                  if ($cont_string_arg =~ /\\n$/) {
+                      $pending_log = undef;
+                  }
+              } elsif ($cleanline =~ /$log_macro_pattern/) {
+                  WARN($pending_log->{lang} . "_LOG_NO_NEWLINE",
+                       "Possible usage of $pending_log->{macro_call} without a trailing newline.\n" .
+                       $pending_log->{herecurr});
+
+                  $pending_log = undef;
+
+                  my $macro_call  = $1;
+                  my $maybe_excl  = $2;
+                  my $string_arg  = $3;
+                  $string_arg =~ s/\s+$//;
+
+                  if ($realfile =~ /\.rs$/ && $maybe_excl ne '!') {
+                      return;
+                  }
+
+                  if ($string_arg !~ /\\n$/ && $string_arg !~ /\n$/) {
+                      $pending_log = {
+                          macro_call => $macro_call,
+                          herecurr => $herecurr,
+                          lang => ($realfile =~ /\.rs$/) ? "Rust" : "C",
+                      };
+                  }
+              }
+          } else {
+              if ($cleanline =~ /$log_macro_pattern/) {
+                  my $macro_call = $1;
+                  my $maybe_excl = $2;
+                  my $string_arg = $3;
+                  $string_arg =~ s/\s+$//;
+
+                  if ($realfile =~ /\.rs$/ && $maybe_excl ne '!') {
+                      return;
+                  }
+
+                  if ($string_arg !~ /\\n$/ && $string_arg !~ /\n$/) {
+                      $pending_log = {
+                          macro_call => $macro_call,
+                          herecurr   => $herecurr,
+                          lang       => ($realfile =~ /\.rs$/) ? "Rust" : "C",
+                      };
+                  }
+              }
+          }
+      }
+  }
+
 # check for .L prefix local symbols in .S files
 		if ($realfile =~ /\.S$/ &&
 		    $line =~ /^\+\s*(?:[A-Z]+_)?SYM_[A-Z]+_(?:START|END)(?:_[A-Z_]+)?\s*\(\s*\.L/) {
@@ -7670,6 +7757,15 @@ sub process {
 		}
 	}
 
+# pending log means a pr_* without an ending newline has not
+# been followed by a pr_cont call with a newline at the end
+  if ($pending_log) {
+    WARN($pending_log->{lang} . "_LOG_NO_NEWLINE",
+      "Usage of $pending_log->{macro_call} without a trailing newline.\n" .
+      $pending_log->{herecurr});
+    $pending_log = undef;
+  }
+
 	# If we have no input at all, then there is nothing to report on
 	# so just keep quiet.
 	if ($#rawlines == -1) {
_

Patches currently in -mm which might be from kurti@invicto.ai are


