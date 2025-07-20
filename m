Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232AA15CD74
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977378; cv=none; b=M+0uxZlNRfeu2yWwQD5hBlt1k/Nf9MTPbPMLM7/OHh95l3T+9oxRu4rFNMMDN1aPyxr5ys5MZ6LJnHodMlbSgBslvXikmM1J+cydb051OWtOfdU68Fk0/ujlzkulT+avOd9DL+jclo7hrP7+I7hPQL/4XLZfXGyRSyrpR/EIcek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977378; c=relaxed/simple;
	bh=rY2fZmgxoN2Kb4gRyY7ntJCmJ+xrAOZqYhya7DHpV5o=;
	h=Date:To:From:Subject:Message-Id; b=sW2qgv+WtWPJTvUiKU1A8u+TJaWrnOfFcnAIvPLcGLBA3xPuD9oOi4FSkOiIzBMAq1ZmiEqXj0FGJi0iHCf70DAdur0/SmX9Vlgy6ejqv2uNa/aAFwMDbABIVsKJW8F+FJk23mYksVOGRCkqUEXeQA+Pr2OPn+7iv4ybk8VGtEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ld2TOJgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ld2TOJgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC187C4CEE3;
	Sun, 20 Jul 2025 02:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977378;
	bh=rY2fZmgxoN2Kb4gRyY7ntJCmJ+xrAOZqYhya7DHpV5o=;
	h=Date:To:From:Subject:From;
	b=Ld2TOJgcJSeDta7IixJTioOvb+aogiAERtrB23+rMyp9YqKMOpJA02H1LlUO7EHHl
	 3JGlFKARZq5EvowsLqLlZs7h8A//fVw8/hIFjcmUsYMlptEiGiy/izZ3IfmOvmJ3oH
	 HjFPVLJiSRi+2Ugo2ZnCGh+Jn5zIZqazmbQyikR0=
Date: Sat, 19 Jul 2025 19:09:37 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,guanwentao@uniontech.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-thermal-remove-duplicate-newlines-in-perror-calls.patch removed from -mm tree
Message-Id: <20250720020937.EC187C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/thermal: remove duplicate newlines in perror calls
has been removed from the -mm tree.  Its filename was
     selftests-thermal-remove-duplicate-newlines-in-perror-calls.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: selftests/thermal: remove duplicate newlines in perror calls
Date: Thu, 10 Jul 2025 21:47:51 +0800

perror() automatically appends a newline character, so the explicit '\n'
in the format strings is redundant and results in duplicate newlines in
the output.

Remove the redundant '\n' characters from perror() calls in
workload_hint_test.c to fix the formatting.

Link: https://lkml.kernel.org/r/F482FB1EC020000C+20250710134751.306096-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Cc: Guan Wentao <guanwentao@uniontech.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c |   14 +++++-----
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c~selftests-thermal-remove-duplicate-newlines-in-perror-calls
+++ a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
@@ -32,12 +32,12 @@ void workload_hint_exit(int signum)
 
 	fd = open(WORKLOAD_ENABLE_ATTRIBUTE, O_RDWR);
 	if (fd < 0) {
-		perror("Unable to open workload type feature enable file\n");
+		perror("Unable to open workload type feature enable file");
 		exit(1);
 	}
 
 	if (write(fd, "0\n", 2) < 0) {
-		perror("Can't disable workload hints\n");
+		perror("Can't disable workload hints");
 		exit(1);
 	}
 
@@ -70,12 +70,12 @@ int main(int argc, char **argv)
 		sprintf(delay_str, "%s\n", argv[1]);
 		fd = open(WORKLOAD_NOTIFICATION_DELAY_ATTRIBUTE, O_RDWR);
 		if (fd < 0) {
-			perror("Unable to open workload notification delay\n");
+			perror("Unable to open workload notification delay");
 			exit(1);
 		}
 
 		if (write(fd, delay_str, strlen(delay_str)) < 0) {
-			perror("Can't set delay\n");
+			perror("Can't set delay");
 			exit(1);
 		}
 
@@ -92,12 +92,12 @@ int main(int argc, char **argv)
 	/* Enable feature via sysfs knob */
 	fd = open(WORKLOAD_ENABLE_ATTRIBUTE, O_RDWR);
 	if (fd < 0) {
-		perror("Unable to open workload type feature enable file\n");
+		perror("Unable to open workload type feature enable file");
 		exit(1);
 	}
 
 	if (write(fd, "1\n", 2) < 0) {
-		perror("Can't enable workload hints\n");
+		perror("Can't enable workload hints");
 		exit(1);
 	}
 
@@ -108,7 +108,7 @@ int main(int argc, char **argv)
 	while (1) {
 		fd = open(WORKLOAD_TYPE_INDEX_ATTRIBUTE, O_RDONLY);
 		if (fd < 0) {
-			perror("Unable to open workload type file\n");
+			perror("Unable to open workload type file");
 			exit(1);
 		}
 
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


