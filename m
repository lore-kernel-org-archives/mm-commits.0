Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D7A286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127188; cv=none; b=DSRSWl95ZQ4i8mxP/TCeCIUxgrB1FfHU8h6DVLhlz/k7ldlNxfag6WDoU9Mo17zR7lEOHX9CTzsB0YI6sQG1lzn2rvVOJPzwVuT9OUk1t938B4jKpRmPxxkyoe7+qY1IEK3s4CIAjUt5eHuN7R8+krQDLa9AYMzaBOYtWO4PSFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127188; c=relaxed/simple;
	bh=sr858sRaRSjzGJ7cofTrpev/zfMX9g1QKkNMyMNuEDU=;
	h=Date:To:From:Subject:Message-Id; b=BVJtCReofwvSn1d2fXqK8e7VlPJ8ZuqG8ygvaofWf11xEQ92IW4tmb2uOzQioxCfoSzK8Zb/cioetVfGrBZ7y4ynyUZQQGCkCA+d2GlsHmaFt+vStOlByfNOYpiq6FYmAgYSq+Uq1USi3JILg+95iN1/sGKJVdRrYcUzmxtGWGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pcuMyzNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pcuMyzNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DB9C4CEE3;
	Thu, 10 Jul 2025 05:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127188;
	bh=sr858sRaRSjzGJ7cofTrpev/zfMX9g1QKkNMyMNuEDU=;
	h=Date:To:From:Subject:From;
	b=pcuMyzNU+EG+EaTsLtBWhonbWjiUAJ4111wGImu4N5/SAi4QHCgH2RZvkzk5COd2D
	 geQJw8cUF7M/jy1jALVd9y1YzbuuLqvulIkAgPtKdD766LX82nC2zieMTFW/bUREK8
	 I7lxJ6lypSClrUqI2QyctnazNfEdy3aC9xxrnoXw=
Date: Wed, 09 Jul 2025 22:59:47 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,briannorris@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-check-for-missing-sentinels-in-id-arrays.patch removed from -mm tree
Message-Id: <20250710055948.52DB9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: check for missing sentinels in ID arrays
has been removed from the -mm tree.  Its filename was
     checkpatch-check-for-missing-sentinels-in-id-arrays.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Norris <briannorris@chromium.org>
Subject: checkpatch: check for missing sentinels in ID arrays
Date: Wed, 2 Jul 2025 16:52:00 -0700

All of the ID tables based on <linux/mod_devicetable.h> (of_device_id,
pci_device_id, ...) require their arrays to end in an empty sentinel
value.  That's usually spelled with an empty initializer entry (e.g.,
"{}"), but also sometimes with explicit 0 entries, field initializers
(e.g., '.id = ""'), or even a macro entry (like PCMCIA_DEVICE_NULL).

Without a sentinel, device-matching code may read out of bounds.

I've found a number of such bugs in driver reviews, and we even
occasionally commit one to the tree.  See commit 5751eee5c620 ("i2c:
nomadik: Add missing sentinel to match table") for example.

Teach checkpatch to find these ID tables, and complain if it looks like
there wasn't a sentinel value.

Test output:

  $ git format-patch -1 a0d15cc47f29be6d --stdout | scripts/checkpatch.pl -
  ERROR: missing sentinel in ID array
  #57: FILE: drivers/i2c/busses/i2c-nomadik.c:1073:
  +static const struct of_device_id nmk_i2c_eyeq_match_table[] = {
   	{
   		.compatible = "XXXXXXXXXXXXXXXXXX",
   		.data = (void *)(NMK_I2C_EYEQ_FLAG_32B_BUS | NMK_I2C_EYEQ_FLAG_IS_EYEQ5),
   	},
   };

  total: 1 errors, 0 warnings, 66 lines checked

  NOTE: For some of the reported defects, checkpatch may be able to
        mechanically convert to the typical style using --fix or --fix-inplace.

  "[PATCH] i2c: nomadik: switch from of_device_is_compatible() to" has style problems, please review.

  NOTE: If any of the errors are false positives, please report
        them to the maintainer, see CHECKPATCH in MAINTAINERS.

When run across the entire tree (scripts/checkpatch.pl -q --types
MISSING_SENTINEL -f ...), false positives exist:

* where macros are used that hide the table from analysis
  (e.g., drivers/gpu/drm/radeon/radeon_drv.c / radeon_PCI_IDS).
  There are fewer than 5 of these.

* where such tables are processed correctly via ARRAY_SIZE() (fewer than
  5 instances). This is by far not the typical usage of *_device_id
  arrays.

* some odd parsing artifacts, where ctx_statement_block() seems to quit
  in the middle of a block due to #if/#else/#endif.

Also, not every "struct *_device_id" is in fact a sentinel-requiring
structure, but even with such types, false positives are very rare.

Link: https://lkml.kernel.org/r/20250702235245.1007351-1-briannorris@chromium.org
Signed-off-by: Brian Norris <briannorris@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-check-for-missing-sentinels-in-id-arrays
+++ a/scripts/checkpatch.pl
@@ -685,6 +685,9 @@ our $tracing_logging_tags = qr{(?xi:
 	[\.\!:\s]*
 )};
 
+# Device ID types like found in include/linux/mod_devicetable.h.
+our $dev_id_types = qr{\b[a-z]\w*_device_id\b};
+
 sub edit_distance_min {
 	my (@arr) = @_;
 	my $len = scalar @arr;
@@ -7679,6 +7682,31 @@ sub process {
 			WARN("DUPLICATED_SYSCTL_CONST",
 				"duplicated sysctl range checking value '$1', consider using the shared one in include/linux/sysctl.h\n" . $herecurr);
 		}
+
+# Check that *_device_id tables have sentinel entries.
+		if (defined $stat && $line =~ /struct\s+$dev_id_types\s+\w+\s*\[\s*\]\s*=\s*\{/) {
+			my $stripped = $stat;
+
+			# Strip diff line prefixes.
+			$stripped =~ s/(^|\n)./$1/g;
+			# Line continuations.
+			$stripped =~ s/\\\n/\n/g;
+			# Strip whitespace, empty strings, zeroes, and commas.
+			$stripped =~ s/""//g;
+			$stripped =~ s/0x0//g;
+			$stripped =~ s/[\s$;,0]//g;
+			# Strip field assignments.
+			$stripped =~ s/\.$Ident=//g;
+
+			if (!(substr($stripped, -4) eq "{}};" ||
+			      substr($stripped, -6) eq "{{}}};" ||
+			      $stripped =~ /ISAPNP_DEVICE_SINGLE_END}};$/ ||
+			      $stripped =~ /ISAPNP_CARD_END}};$/ ||
+			      $stripped =~ /NULL};$/ ||
+			      $stripped =~ /PCMCIA_DEVICE_NULL};$/)) {
+				ERROR("MISSING_SENTINEL", "missing sentinel in ID array\n" . "$here\n$stat\n");
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from briannorris@chromium.org are


