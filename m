Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967E413BADD
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645200; cv=none; b=IcI/QXfCoX7rBYt3JwhZLePsKzB341Vm6/EWEySNhOQff2+13Lbb3v7f5cfy4qBhxqOIl0PUCg6Wka3jr5MXEU6yPPSivypZlBoagFe5BFh7S3c9Ll2ndfs3SvFEkNVi48xBqt+mgiREv5Vy27DAN2hRB7XxqpcE2mUiqyxLUjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645200; c=relaxed/simple;
	bh=RjfDSjFN9kz1Xzry283HOiNP4LL77fN4Z5N3SY3cjl8=;
	h=Date:To:From:Subject:Message-Id; b=IPek6+MLBAiU9hlyau8GBXv06fKx7lXCthNxt8SSqq7dgZND32Kvpd5ZqU/BwrT06QAsMFqX9+wGgem+7/qEzVAWXn9dXGFkRiNCQBdVMJ5qJ4sht5blayWpoxephmVDPQwMaFiCX261M3T9s2UGKFQIYimusa32KstTkuFia/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQ20ihyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQ20ihyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66910C433F1;
	Thu, 22 Feb 2024 23:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645200;
	bh=RjfDSjFN9kz1Xzry283HOiNP4LL77fN4Z5N3SY3cjl8=;
	h=Date:To:From:Subject:From;
	b=CQ20ihyhyQWnooMmfwkgeBJY9+OyrhfP2qas2ZjjhQuAJ/JduvnJrvsMEysyHGCyV
	 ONMwcbuBkwt/J10vYz9Tk9jCxpHDZj6M0nmPrTSYTfPoJxj0BAH1txFPFOxFxdqCaN
	 UiZsz/QwEWkE2RU/uBnYsPcCSL1N3e63kS0UjAnM=
Date: Thu, 22 Feb 2024 15:39:59 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kbuild-raise-the-minimum-supported-version-of-llvm-to-1301.patch removed from -mm tree
Message-Id: <20240222234000.66910C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kbuild: raise the minimum supported version of LLVM to 13.0.1
has been removed from the -mm tree.  Its filename was
     kbuild-raise-the-minimum-supported-version-of-llvm-to-1301.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: kbuild: raise the minimum supported version of LLVM to 13.0.1
Date: Thu, 25 Jan 2024 15:55:07 -0700

Patch series "Bump the minimum supported version of LLVM to 13.0.1".

This series bumps the minimum supported version of LLVM for building the
kernel to 13.0.1.  The first patch does the bump and all subsequent
patches clean up all the various workarounds and checks for earlier
versions.

Quoting the first patch's commit message for those that were only on CC
for the clean ups:

  When __builtin_mul_overflow() has arguments that differ in terms of
  signedness and width, LLVM may generate a libcall to __muloti4 because
  it performs the checks in terms of 65-bit multiplication. This issue
  becomes harder to hit (but still possible) after LLVM 12.0.0, which
  includes a special case for matching widths but different signs.

  To gain access to this special case, which the kernel can take advantage
  of when calls to __muloti4 appear, bump the minimum supported version of
  LLVM for building the kernel to 13.0.1. 13.0.1 was chosen because there
  is minimal impact to distribution support while allowing a few more
  workarounds to be dropped in the kernel source than if 12.0.0 were
  chosen. Looking at container images of up to date distribution versions:

    archlinux:latest              clang version 16.0.6
    debian:oldoldstable-slim      clang version 7.0.1-8+deb10u2 (tags/RELEASE_701/final)
    debian:oldstable-slim         Debian clang version 11.0.1-2
    debian:stable-slim            Debian clang version 14.0.6
    debian:testing-slim           Debian clang version 16.0.6 (19)
    debian:unstable-slim          Debian clang version 16.0.6 (19)
    fedora:38                     clang version 16.0.6 (Fedora 16.0.6-3.fc38)
    fedora:latest                 clang version 17.0.6 (Fedora 17.0.6-1.fc39)
    fedora:rawhide                clang version 17.0.6 (Fedora 17.0.6-1.fc40)
    opensuse/leap:latest          clang version 15.0.7
    opensuse/tumbleweed:latest    clang version 17.0.6
    ubuntu:focal                  clang version 10.0.0-4ubuntu1
    ubuntu:latest                 Ubuntu clang version 14.0.0-1ubuntu1.1
    ubuntu:rolling                Ubuntu clang version 16.0.6 (15)
    ubuntu:devel                  Ubuntu clang version 17.0.6 (3)

  The only distribution that gets left behind is Debian Bullseye, as the
  default version is 11.0.1; other distributions either have a newer
  version than 13.0.1 or one older than the current minimum of 11.0.0.
  Debian has easy access to more recent LLVM versions through
  apt.llvm.org, so this is not as much of a concern. There are also the
  kernel.org LLVM toolchains, which should work with distributions with
  glibc 2.28 and newer.

  Another benefit of slimming up the number of supported versions of LLVM
  for building the kernel is reducing the build capacity needed to support
  a matrix that builds with each supported version, which allows a matrix
  to reallocate the freed up build capacity towards something else, such
  as more configuration combinations.

This passes my build matrix with all supported versions.

This is based on Andrew's mm-nonmm-unstable to avoid trivial conflicts
with my series to update the LLVM links across the repository [1] but I
can easily rebase it to linux-kbuild if Masahiro would rather these
patches go through there (and defer the conflict resolution to the merge
window).

[1]: https://lore.kernel.org/20240109-update-llvm-links-v1-0-eb09b59db071@kernel.org/


This patch (of 11):

When __builtin_mul_overflow() has arguments that differ in terms of
signedness and width, LLVM may generate a libcall to __muloti4 because it
performs the checks in terms of 65-bit multiplication.  This issue becomes
harder to hit (but still possible) after LLVM 12.0.0, which includes a
special case for matching widths but different signs.

To gain access to this special case, which the kernel can take advantage
of when calls to __muloti4 appear, bump the minimum supported version of
LLVM for building the kernel to 13.0.1.  13.0.1 was chosen because there
is minimal impact to distribution support while allowing a few more
workarounds to be dropped in the kernel source than if 12.0.0 were chosen.
Looking at container images of up to date distribution versions:

  archlinux:latest              clang version 16.0.6
  debian:oldoldstable-slim      clang version 7.0.1-8+deb10u2 (tags/RELEASE_701/final)
  debian:oldstable-slim         Debian clang version 11.0.1-2
  debian:stable-slim            Debian clang version 14.0.6
  debian:testing-slim           Debian clang version 16.0.6 (19)
  debian:unstable-slim          Debian clang version 16.0.6 (19)
  fedora:38                     clang version 16.0.6 (Fedora 16.0.6-3.fc38)
  fedora:latest                 clang version 17.0.6 (Fedora 17.0.6-1.fc39)
  fedora:rawhide                clang version 17.0.6 (Fedora 17.0.6-1.fc40)
  opensuse/leap:latest          clang version 15.0.7
  opensuse/tumbleweed:latest    clang version 17.0.6
  ubuntu:focal                  clang version 10.0.0-4ubuntu1
  ubuntu:latest                 Ubuntu clang version 14.0.0-1ubuntu1.1
  ubuntu:rolling                Ubuntu clang version 16.0.6 (15)
  ubuntu:devel                  Ubuntu clang version 17.0.6 (3)

The only distribution that gets left behind is Debian Bullseye, as the
default version is 11.0.1; other distributions either have a newer version
than 13.0.1 or one older than the current minimum of 11.0.0.  Debian has
easy access to more recent LLVM versions through apt.llvm.org, so this is
not as much of a concern.  There are also the kernel.org LLVM toolchains,
which should work with distributions with glibc 2.28 and newer.

Another benefit of slimming up the number of supported versions of LLVM
for building the kernel is reducing the build capacity needed to support a
matrix that builds with each supported version, which allows a matrix to
reallocate the freed up build capacity towards something else, such as
more configuration combinations.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-0-f5ff9bda41c5@kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/1975
Link: https://github.com/llvm/llvm-project/issues/38013
Link: https://github.com/llvm/llvm-project/commit/3203143f1356a4e4e3ada231156fc6da6e1a9f9d
Link: https://mirrors.edge.kernel.org/pub/tools/llvm/
Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-1-f5ff9bda41c5@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/process/changes.rst |    2 +-
 scripts/min-tool-version.sh       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/process/changes.rst~kbuild-raise-the-minimum-supported-version-of-llvm-to-1301
+++ a/Documentation/process/changes.rst
@@ -30,7 +30,7 @@ you probably needn't concern yourself wi
         Program        Minimal version       Command to check the version
 ====================== ===============  ========================================
 GNU C                  5.1              gcc --version
-Clang/LLVM (optional)  11.0.0           clang --version
+Clang/LLVM (optional)  13.0.1           clang --version
 Rust (optional)        1.74.1           rustc --version
 bindgen (optional)     0.65.1           bindgen --version
 GNU make               3.82             make --version
--- a/scripts/min-tool-version.sh~kbuild-raise-the-minimum-supported-version-of-llvm-to-1301
+++ a/scripts/min-tool-version.sh
@@ -29,7 +29,7 @@ llvm)
 	elif [ "$SRCARCH" = loongarch ]; then
 		echo 18.0.0
 	else
-		echo 11.0.0
+		echo 13.0.1
 	fi
 	;;
 rustc)
_

Patches currently in -mm which might be from nathan@kernel.org are


