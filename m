Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F942AD32
	for <mm-commits@vger.kernel.org>; Sat,  8 Feb 2025 02:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738981679; cv=none; b=adgVaKSC7a0wZfrOp6D9NoP6eXwKukGU2eC3LXZOwUzvboTLXs3Bkt7b23qD3zRnbsrnbavLKXzIB+rPur2Pzct85AWzvqOBmBunQ9WAa1gaoWNYQuXNiXVTXBAUmRV/DJtLXjBBXQFrdmeHqHjLM1i6VOt1Wttrv9xNp6Sa9RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738981679; c=relaxed/simple;
	bh=OpsMfh42dvLpNV4/UH1MjFGHLMbtrMfkKA9CS0daqOI=;
	h=Date:To:From:Subject:Message-Id; b=HkvHPtjMAigdQNFvboHDm5soT86WwVHWjn5Z+krf4dijOIJ52vbmDVejsEpnPXKWixn7nzW3lhCsOZm2TKRzYZfAHxcnS8pTOYf8b5AdYD1+ZVfPAWP1FaUvzwlGekDFZi1u7f+FFnboDhnGqYMyFp3oMOtjEEX4599grqBj8PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wRVdo7+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wRVdo7+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F5EC4CED1;
	Sat,  8 Feb 2025 02:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738981679;
	bh=OpsMfh42dvLpNV4/UH1MjFGHLMbtrMfkKA9CS0daqOI=;
	h=Date:To:From:Subject:From;
	b=wRVdo7+XxQYDsndtgigPMfZpbVqh0f5evDE9FlBgLKXi6IdHIG1/QDzz0/UhMWt0q
	 8sQ2s1BIaeJR4RVN/okMySonzJ448N7K1fBbZLjB4JQc9LjJtk1lAkYX0rHl4EGLGp
	 U/J3RSWzZF9jj3OaugnunhE9HkHp8tbXI5XuvaWA=
Date: Fri, 07 Feb 2025 18:27:58 -0800
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,gary@garyguo.net,dwaipayanray1@gmail.com,charmitro@posteo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,apw@canonical.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,kurti@invicto.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch added to mm-nonmm-unstable branch
Message-Id: <20250208022759.28F5EC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add warning for pr_* and dev_* macros without a trailing newline
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch

