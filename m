Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D7135AC01
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028746; cv=none; b=HasVnEZf8F0015nr9gVAoJj8jcjRs2InDD233er69xCe0na3xFz3UTg+ztsAhehxB9jPcy2Vm2WqxI6vY+A9x+z4FGFNShMXbWDj1UaAbXPdVTi0wc7vYYQsBXccSWEouN/SfkDAnrUucmfB2NJEfvKsolQeR3vLrKxXD/pjbRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028746; c=relaxed/simple;
	bh=XWy/BopNoahg5JNA5irV0DZLMruqd14o5s9u887TcHA=;
	h=Date:To:From:Subject:Message-Id; b=uXCayUaAuX267JqrzhqG/eZzfYIdoyXr9cYBiimB0adTfvchC6ETG5aM7YmMIAddbqeVk6Ojet5znIJVZv1Qp6yU0g2guJyKH/ybcDCZuaVRLZJHtthJOzgtGOoHvjLUV2fL8Kfa04s8/oqikVo0uOcnqKzE7GDbS7ydDOtx+Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JvyTE1sF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JvyTE1sF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F841F00899;
	Fri, 29 May 2026 04:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028744;
	bh=ofcByyTtSepY+9DSX3CxWNm8uY+thR0jt4cfSr3KW8g=;
	h=Date:To:From:Subject;
	b=JvyTE1sFiKGFJhUBDX1+lfkc7/H+L5MxOU2SsBRp9w6+7U8XtCSnDtlzMq0dFnkAK
	 OiH8Du8e7uJoWNVMjjgX9p0Rv5jmUs8qGgI4NdEvHA+hBiqKZDzLZG2EgLxaxB2bbg
	 zpDaD+9yhcNX0XE8bHQ+f5mrI1N7JZSBZpiDPi9k=
Date: Thu, 28 May 2026 21:25:44 -0700
To: mm-commits@vger.kernel.org,joe@perches.com,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_maintainer-add-json-output-mode.patch removed from -mm tree
Message-Id: <20260529042544.B0F841F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_maintainer: add --json output mode
has been removed from the -mm tree.  Its filename was
     get_maintainer-add-json-output-mode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: get_maintainer: add --json output mode
Date: Wed, 8 Apr 2026 15:45:42 -0400

Add a --json flag to get_maintainer.pl that emits structured JSON output,
making results machine-parseable for CI systems, IDE integrations, and
AI-assisted development tools.

The JSON output includes a maintainers array with structured name, email,
and role fields, plus optional arrays for scm, status, subsystem, web, and
bug information when those flags are enabled.

Normal text output behavior is completely unchanged when --json is not
specified.

Assisted-by: Claude:claude-opus-4-6
Link: https://lore.kernel.org/20260408194542.1354549-1-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   75 +++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 31 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-add-json-output-mode
+++ a/scripts/get_maintainer.pl
@@ -21,6 +21,7 @@ use Cwd;
 use File::Find;
 use File::Spec::Functions;
 use open qw(:std :encoding(UTF-8));
+use JSON::PP;
 
 my $cur_path = fastgetcwd() . '/';
 my $lk_path = "./";
@@ -68,6 +69,7 @@ my $pattern_depth = 0;
 my $self_test = undef;
 my $version = 0;
 my $help = 0;
+my $json = 0;
 my $find_maintainer_files = 0;
 my $maintainer_path;
 my $vcs_used = 0;
@@ -285,6 +287,7 @@ if (!GetOptions(
 		'find-maintainer-files' => \$find_maintainer_files,
 		'mpath|maintainer-path=s' => \$maintainer_path,
 		'self-test:s' => \$self_test,
+		'json!' => \$json,
 		'v|version' => \$version,
 		'h|help|usage' => \$help,
 		)) {
@@ -650,39 +653,48 @@ my %deduplicate_name_hash = ();
 my %deduplicate_address_hash = ();
 
 my @maintainers = get_maintainers();
-if (@maintainers) {
-    @maintainers = merge_email(@maintainers);
-    output(@maintainers);
-}
-
-if ($scm) {
-    @scm = uniq(@scm);
-    output(@scm);
-}
-
-if ($output_substatus) {
-    @substatus = uniq(@substatus);
-    output(@substatus);
-}
-
-if ($status) {
-    @status = uniq(@status);
-    output(@status);
-}
 
-if ($subsystem) {
-    @subsystem = uniq(@subsystem);
-    output(@subsystem);
-}
-
-if ($web) {
-    @web = uniq(@web);
-    output(@web);
-}
+@maintainers = merge_email(@maintainers) if (@maintainers);
+@scm = uniq(@scm) if ($scm);
+@substatus = uniq(@substatus) if ($output_substatus);
+@status = uniq(@status) if ($status);
+@subsystem = uniq(@subsystem) if ($subsystem);
+@web = uniq(@web) if ($web);
+@bug = uniq(@bug) if ($bug);
+
+if ($json) {
+    my @json_maintainers;
+    for my $m (@maintainers) {
+	my ($addr, $role);
+	if ($output_roles && $m =~ /^(.*?)\s+\((.+)\)\s*$/) {
+	    $addr = $1;
+	    $role = $2;
+	} else {
+	    $addr = $m;
+	}
+	my ($name, $email_addr) = parse_email($addr);
+	my %entry = (name => $name, email => $email_addr);
+	$entry{role} = $role if (defined $role && $role ne '');
+	push(@json_maintainers, \%entry);
+    }
+
+    my %result = (maintainers => \@json_maintainers);
+    $result{scm} = \@scm if ($scm);
+    $result{status} = \@status if ($status);
+    $result{subsystem} = \@subsystem if ($subsystem);
+    $result{web} = \@web if ($web);
+    $result{bug} = \@bug if ($bug);
 
-if ($bug) {
-    @bug = uniq(@bug);
-    output(@bug);
+    my $json_encoder = JSON::PP->new->canonical->utf8;
+    print($json_encoder->encode(\%result) . "\n");
+} else {
+    output(@maintainers) if (@maintainers);
+    output(@scm) if ($scm);
+    output(@substatus) if ($output_substatus);
+    output(@status) if ($status);
+    output(@subsystem) if ($subsystem);
+    output(@web) if ($web);
+    output(@bug) if ($bug);
 }
 
 exit($exit);
@@ -1104,6 +1116,7 @@ Output type options:
   --separator [, ] => separator for multiple entries on 1 line
     using --separator also sets --nomultiline if --separator is not [, ]
   --multiline => print 1 entry per line
+  --json => output results as JSON
 
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
_

Patches currently in -mm which might be from sashal@kernel.org are


