Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAB7140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189500; cv=none; b=r0w2yRnDei+S2Umn3QjQCZ4vwkuiD0QHZ/ohSUddFB1gAkK1HNmfdSEqTI9UPmhhYXFxb82JI9KICTeX8kfZBtrG5nrI6CHK78KKvJxifIw5wJ8DdmaYtJC6iYWOSN8TViuSV/H8cA5J3+YGP0gcMIRJi2X3LWEqQ6CvIXvfCiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189500; c=relaxed/simple;
	bh=Ae5BCp5DwZ/Gww+h721XdWWfVW3KnkW6f19XiqvowoM=;
	h=Date:To:From:Subject:Message-Id; b=PVMYrHNuJwbXIFE4Y2zNDLelJY8QYA2vk78VbetJzBvUvzyaQOOpydO4kterDZ9Hxal/ybGVbCLMBa2QgbcEmmvRcU7o0T8XmH0O1fKjNUdEpJXRUo9gT92g9qnW8vWA0mLJ6Hd7xVx0u8ayu0CtJMD7g+uwE+lFsbM/3GXvfjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CbuzlLTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CbuzlLTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF67C4CEEC;
	Mon, 17 Mar 2025 05:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189500;
	bh=Ae5BCp5DwZ/Gww+h721XdWWfVW3KnkW6f19XiqvowoM=;
	h=Date:To:From:Subject:From;
	b=CbuzlLTrpJCVblXNTloHwORm6JjlrQGVwY/8xk1ODKYROPSZ3wXtMJtTgdOoy0C+K
	 BBeAIAHzd3PfjyPlvwNzqjTUdVtP67/yy/Oc2P/gqtg3DyzdtleSyITf/ud5JQMNDp
	 sk3EejDWUSkfAl2Hmc0UDOsWdzHWQp2RQeL+hxmQ=
Date: Sun, 16 Mar 2025 22:31:39 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tytso@mit.edu,lorenzo.stoakes@oracle.com,linux@leemhuis.info,kees@kernel.org,joe@perches.com,geert+renesas@glider.be,bryan.odonoghue@linaro.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_maintainer-add-substatus-for-reporting-subsystem-status.patch removed from -mm tree
Message-Id: <20250317053140.3FF67C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_maintainer: add --substatus for reporting subsystem status
has been removed from the -mm tree.  Its filename was
     get_maintainer-add-substatus-for-reporting-subsystem-status.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: get_maintainer: add --substatus for reporting subsystem status
Date: Mon, 03 Feb 2025 12:13:16 +0100

Patch series "get_maintainer: report subsystem status separately", v2.

The subsystem status (S: field) can inform a patch submitter if the
subsystem is well maintained or e.g.  maintainers are missing.  In
get_maintainer, it is currently reported with --role(stats) by adjusting
the maintainer role for any status different from Maintained.  This has
two downsides:

- if a subsystem has only reviewers or mailing lists and no maintainers,
  the status is not reported. For example Orphan subsystems typically
  have no maintainers so there's nobody to report as orphan minder.

- the Supported status means that someone is paid for maintaining, but
  it is reported as "supporter" for all the maintainers, which can be
  incorrect (only some of them may be paid). People (including myself)
  have been also confused about what "supporter" means.

The second point has been brought up in 2022 and the discussion in the end
resulted in adjusting documentation only [1].  I however agree with Ted's
points that it's misleading to take the subsystem status and apply it to
all maintainers [2].

The attempt to modify get_maintainer output was retracted after Joe
objected that the status becomes not reported at all [3].  This series
addresses that concern by reporting the status (unless it's the most
common Maintained one) on separate lines that follow the reported emails,
using a new --substatus parameter.  Care is taken to reduce the noise to
minimum by not reporting the most common Maintained status, by default
require no opt-in that would need the users to discover the new parameter,
and at the same time not to break existing git --cc-cmd usage.

[1] https://lore.kernel.org/all/20221006162413.858527-1-bryan.odonoghue@linaro.org/
[2] https://lore.kernel.org/all/Yzen4X1Na0MKXHs9@mit.edu/
[3] https://lore.kernel.org/all/30776fe75061951777da8fa6618ae89bea7a8ce4.camel@perches.com/


This patch (of 2):

The subsystem status is currently reported with --role(stats) by adjusting
the maintainer role for any status different from Maintained.  This has
two downsides:

- if a subsystem has only reviewers or mailing lists and no maintainers,
  the status is not reported (i.e. typically, Orphan subsystems have no
  maintainers)

- the Supported status means that someone is paid for maintaining, but
  it is reported as "supporter" for all the maintainers, which can be
  incorrect. People have been also confused about what "supporter"
  means.

This patch introduces a new --substatus option and functionality aimed to
report the subsystem status separately, without adjusting the reported
maintainer role.  After the e-mails are output, the status of subsystems
will follow, for example:

...
linux-kernel@vger.kernel.org (open list:LIBRARY CODE)
LIBRARY CODE status: Supported

In order to allow replacing the role rewriting seamlessly, the new
option works as follows:

- it is automatically enabled when --email and --role are enabled
  (the defaults include --email and --rolestats which implies --role)

- usages with --norolestats e.g. for git's --cc-cmd will thus need no
  adjustments

- the most common Maintained status is not reported at all, to reduce
  unnecessary noise

- THE REST catch-all section (contains lkml) status is not reported

- the existing --subsystem and --status options are unaffected so their
  users will need no adjustments

[vbabka@suse.cz: require that script output goes to a terminal]
  Link: https://lkml.kernel.org/r/66c2bf7a-9119-4850-b6b8-ac8f426966e1@suse.cz
Link: https://lkml.kernel.org/r/20250203-b4-get_maintainer-v2-0-83ba008b491f@suse.cz
Link: https://lkml.kernel.org/r/20250203-b4-get_maintainer-v2-1-83ba008b491f@suse.cz
Fixes: c1565b6f7b53 ("get_maintainer: add --substatus for reporting subsystem status")
Closes: https://lore.kernel.org/all/7aodxv46lj6rthjo4i5zhhx2lybrhb4uknpej2dyz3e7im5w3w@w23bz6fx3jnn/
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Uwe Kleine-K=F6nig <u.kleine-koenig@baylibre.com>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-add-substatus-for-reporting-subsystem-status
+++ a/scripts/get_maintainer.pl
@@ -50,6 +50,7 @@ my $output_multiline = 1;
 my $output_separator = ", ";
 my $output_roles = 0;
 my $output_rolestats = 1;
+my $output_substatus = undef;
 my $output_section_maxlen = 50;
 my $scm = 0;
 my $tree = 1;
@@ -269,6 +270,7 @@ if (!GetOptions(
 		'separator=s' => \$output_separator,
 		'subsystem!' => \$subsystem,
 		'status!' => \$status,
+		'substatus!' => \$output_substatus,
 		'scm!' => \$scm,
 		'tree!' => \$tree,
 		'web!' => \$web,
@@ -314,6 +316,10 @@ $output_multiline = 0 if ($output_separa
 $output_rolestats = 1 if ($interactive);
 $output_roles = 1 if ($output_rolestats);
 
+if (!defined $output_substatus) {
+    $output_substatus = $email && $output_roles && -t STDOUT;
+}
+
 if ($sections || $letters ne "") {
     $sections = 1;
     $email = 0;
@@ -637,6 +643,7 @@ my @web = ();
 my @bug = ();
 my @subsystem = ();
 my @status = ();
+my @substatus = ();
 my %deduplicate_name_hash = ();
 my %deduplicate_address_hash = ();
 
@@ -651,6 +658,11 @@ if ($scm) {
     output(@scm);
 }
 
+if ($output_substatus) {
+    @substatus = uniq(@substatus);
+    output(@substatus);
+}
+
 if ($status) {
     @status = uniq(@status);
     output(@status);
@@ -859,6 +871,7 @@ sub get_maintainers {
     @bug = ();
     @subsystem = ();
     @status = ();
+    @substatus = ();
     %deduplicate_name_hash = ();
     %deduplicate_address_hash = ();
     if ($email_git_all_signature_types) {
@@ -1073,6 +1086,7 @@ MAINTAINER field selection options:
     --remove-duplicates => minimize duplicate email names/addresses
     --roles => show roles (status:subsystem, git-signer, list, etc...)
     --rolestats => show roles and statistics (commits/total_commits, %)
+    --substatus => show subsystem status if not Maintained (default: match --roles when output is tty)"
     --file-emails => add email addresses found in -f file (default: 0 (off))
     --fixes => for patches, add signatures of commits with 'Fixes: <commit>' (default: 1 (on))
   --scm => print SCM tree(s) if any
@@ -1335,7 +1349,9 @@ sub add_categories {
     my $start = find_starting_index($index);
     my $end = find_ending_index($index);
 
-    push(@subsystem, $typevalue[$start]);
+    my $subsystem = $typevalue[$start];
+    push(@subsystem, $subsystem);
+    my $status = "Unknown";
 
     for ($i = $start + 1; $i < $end; $i++) {
 	my $tv = $typevalue[$i];
@@ -1386,8 +1402,8 @@ sub add_categories {
 		}
 	    } elsif ($ptype eq "R") {
 		if ($email_reviewer) {
-		    my $subsystem = get_subsystem_name($i);
-		    push_email_addresses($pvalue, "reviewer:$subsystem" . $suffix);
+		    my $subs = get_subsystem_name($i);
+		    push_email_addresses($pvalue, "reviewer:$subs" . $suffix);
 		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue . $suffix);
@@ -1397,9 +1413,14 @@ sub add_categories {
 		push(@bug, $pvalue . $suffix);
 	    } elsif ($ptype eq "S") {
 		push(@status, $pvalue . $suffix);
+		$status = $pvalue;
 	    }
 	}
     }
+
+    if ($subsystem ne "THE REST" and $status ne "Maintained") {
+	push(@substatus, $subsystem . " status: " . $status . $suffix)
+    }
 }
 
 sub email_inuse {
@@ -1903,6 +1924,7 @@ EOT
 		$done = 1;
 		$output_rolestats = 0;
 		$output_roles = 0;
+		$output_substatus = 0;
 		last;
 	    } elsif ($nr =~ /^\d+$/ && $nr > 0 && $nr <= $count) {
 		$selected{$nr - 1} = !$selected{$nr - 1};
_

Patches currently in -mm which might be from vbabka@suse.cz are


